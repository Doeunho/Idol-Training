using UnityEngine;
using System.Collections.Generic;
using UnityEngine.UI;
using Cysharp.Threading.Tasks;
using System;
using System.Threading;
using System.Linq;

public class RandomAnimationList : MonoBehaviour
{
    [Header("������Ʈ ����")]
    [SerializeField] private Transform instructorCharacterRoot;
    [SerializeField, Tooltip("ĳ���͸� ã�� �� ���� �� ����� ���")]
    private string characterPath = "InstructorCharacterRoot";

    [Header("��Ʈ ����")]
    [SerializeField] private int setsCount = 3;
    [SerializeField] private int exercisesPerSet = 3;
    [SerializeField] private float initialDelaySeconds = 9f;
    [SerializeField] private float restBetweenSetsSeconds = 60f;

    [Header("���ҽ� ����")]
    [SerializeField] private string trainingDataPath = "Training";

    // ĳ�õ� ������Ʈ��
    private Animator activeCharacterAnimator;
    private readonly List<List<TrainingData>> exerciseSets = new();
    private readonly List<TrainingData> availableTrainings = new();
    private CancellationTokenSource cts;

    // ���� ���� ����
    private bool isTraining;
    private int currentSetIndex;
    private int currentExerciseIndex;

    public event Action<TrainingData> OnExerciseStart;
    public event Action<int, int> OnSetProgress; // currentSet, totalSets
    public event Action OnTrainingComplete;

    private void OnDisable()
    {
        CancelTraining();
    }

    private void OnDestroy()
    {
        CancelTraining();
    }

    private void CancelTraining()
    {
        if (cts != null)
        {
            cts.Cancel();
            cts.Dispose();
            cts = null;
        }
        isTraining = false;
    }

    public void Initialize()
    {
        FindCharacterAnimator();
        LoadTrainingData();
        InitializeExerciseSets();
    }

    private void FindCharacterAnimator()
    {
        // ĳ���� ã�� ���� ����
        if (instructorCharacterRoot == null)
        {
            instructorCharacterRoot = GameObject.Find(characterPath)?.transform;
            if (instructorCharacterRoot == null)
            {
                Debug.LogError($"[RandomAnimationList] {characterPath}�� ã�� �� �����ϴ�!");
                return;
            }
        }

        // Ȱ��ȭ�� ĳ���� ã��
        foreach (Transform child in instructorCharacterRoot)
        {
            if (!child.gameObject.activeSelf) continue;

            activeCharacterAnimator = child.GetComponent<Animator>();
            if (activeCharacterAnimator != null)
            {
                Debug.Log($"[RandomAnimationList] Ȱ��ȭ�� ĳ���� ã��: {child.name}");
                return;
            }
        }

        Debug.LogError("[RandomAnimationList] Ȱ��ȭ�� ĳ������ Animator�� ã�� �� �����ϴ�!");
    }

    private void LoadTrainingData()
    {
        availableTrainings.Clear();

        var loadedTrainings = Resources.LoadAll<TrainingData>(trainingDataPath);
        if (loadedTrainings == null || loadedTrainings.Length == 0)
        {
            Debug.LogError($"[RandomAnimationList] '{trainingDataPath}' ��ο��� TrainingData�� ã�� �� �����ϴ�!");
            return;
        }

        availableTrainings.AddRange(loadedTrainings);
        Debug.Log($"[RandomAnimationList] {availableTrainings.Count}���� Ʈ���̴� ������ �ε� �Ϸ�");
    }

    private void InitializeExerciseSets()
    {
        exerciseSets.Clear();
        for (int i = 0; i < setsCount; i++)
        {
            exerciseSets.Add(new List<TrainingData>());
        }
    }

    private void SelectRandomExercises()
    {
        if (availableTrainings.Count == 0)
        {
            Debug.LogError("[RandomAnimationList] ��� ������ Ʈ���̴� �����Ͱ� �����ϴ�!");
            return;
        }

        InitializeExerciseSets();

        var random = new System.Random();
        for (int setIndex = 0; setIndex < setsCount; setIndex++)
        {
            var shuffledExercises = availableTrainings
                .OrderBy(x => random.Next())
                .Take(exercisesPerSet)
                .ToList();

            exerciseSets[setIndex].AddRange(shuffledExercises);
        }
    }

    public async UniTaskVoid StartTraining()
    {
        if (isTraining)
        {
            Debug.LogWarning("[RandomAnimationList] �̹� Ʈ���̴��� ���� ���Դϴ�.");
            return;
        }

        try
        {
            CancelTraining();
            cts = new CancellationTokenSource();
            isTraining = true;
            currentSetIndex = 0;
            currentExerciseIndex = 0;

            if (activeCharacterAnimator == null)
            {
                FindCharacterAnimator();
                if (activeCharacterAnimator == null) return;
            }

            await UniTask.Delay(TimeSpan.FromSeconds(initialDelaySeconds), cancellationToken: cts.Token);
            SelectRandomExercises();

            for (int setIndex = 0; setIndex < exerciseSets.Count; setIndex++)
            {
                currentSetIndex = setIndex;
                OnSetProgress?.Invoke(setIndex + 1, exerciseSets.Count);

                foreach (var exercise in exerciseSets[setIndex])
                {
                    if (!isTraining) return;

                    OnExerciseStart?.Invoke(exercise);
                    await PlayExerciseAndWaitForCompletion(exercise, cts.Token);
                    currentExerciseIndex++;
                }

                if (setIndex < exerciseSets.Count - 1)
                {
                    await UniTask.Delay(TimeSpan.FromSeconds(restBetweenSetsSeconds), cancellationToken: cts.Token);
                }
            }

            OnTrainingComplete?.Invoke();
        }
        catch (OperationCanceledException)
        {
            Debug.Log("[RandomAnimationList] Ʈ���̴��� ��ҵǾ����ϴ�.");
        }
        catch (Exception ex)
        {
            Debug.LogError($"[RandomAnimationList] Ʈ���̴� �� ���� �߻�: {ex}");
        }
        finally
        {
            isTraining = false;
        }
    }

    private async UniTask PlayExerciseAndWaitForCompletion(TrainingData exercise, CancellationToken cancellationToken)
    {
        if (exercise == null || activeCharacterAnimator == null) return;

        activeCharacterAnimator.runtimeAnimatorController = exercise.trainingController;
        activeCharacterAnimator.SetTrigger(exercise.trainingName);

        float animationLength = GetCurrentAnimationLength();
        await UniTask.Delay(TimeSpan.FromSeconds(animationLength), cancellationToken: cancellationToken);
    }

    private float GetCurrentAnimationLength()
    {
        if (activeCharacterAnimator == null) return 3f;

        var clipInfo = activeCharacterAnimator.GetCurrentAnimatorClipInfo(0);
        return clipInfo.Length > 0 ? clipInfo[0].clip.length : 3f;
    }

    // ���� ��Ȳ Ȯ�ο� �޼����
    public float GetProgress()
    {
        if (exerciseSets.Count == 0) return 0f;

        int totalExercises = exerciseSets.Count * exercisesPerSet;
        int completedExercises = (currentSetIndex * exercisesPerSet) + currentExerciseIndex;
        return (float)completedExercises / totalExercises;
    }

    public (int currentSet, int totalSets) GetSetProgress()
    {
        return (currentSetIndex + 1, exerciseSets.Count);
    }

    public bool IsTraining() => isTraining;
}
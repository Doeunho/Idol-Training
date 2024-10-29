using UnityEngine;
using System.Collections.Generic;
using UnityEngine.UI;
using Cysharp.Threading.Tasks;
using System;
using System.Threading;
using System.Linq;

public class RandomAnimationList : MonoBehaviour
{
    [Header("컴포넌트 설정")]
    [SerializeField] private Transform instructorCharacterRoot;
    [SerializeField, Tooltip("캐릭터를 찾을 수 없을 때 사용할 경로")]
    private string characterPath = "InstructorCharacterRoot";

    [Header("세트 설정")]
    [SerializeField] private int setsCount = 3;
    [SerializeField] private int exercisesPerSet = 3;
    [SerializeField] private float initialDelaySeconds = 9f;
    [SerializeField] private float restBetweenSetsSeconds = 60f;

    [Header("리소스 설정")]
    [SerializeField] private string trainingDataPath = "Training";

    // 캐시된 컴포넌트들
    private Animator activeCharacterAnimator;
    private readonly List<List<TrainingData>> exerciseSets = new();
    private readonly List<TrainingData> availableTrainings = new();
    private CancellationTokenSource cts;

    // 현재 상태 추적
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
        // 캐릭터 찾기 로직 개선
        if (instructorCharacterRoot == null)
        {
            instructorCharacterRoot = GameObject.Find(characterPath)?.transform;
            if (instructorCharacterRoot == null)
            {
                Debug.LogError($"[RandomAnimationList] {characterPath}를 찾을 수 없습니다!");
                return;
            }
        }

        // 활성화된 캐릭터 찾기
        foreach (Transform child in instructorCharacterRoot)
        {
            if (!child.gameObject.activeSelf) continue;

            activeCharacterAnimator = child.GetComponent<Animator>();
            if (activeCharacterAnimator != null)
            {
                Debug.Log($"[RandomAnimationList] 활성화된 캐릭터 찾음: {child.name}");
                return;
            }
        }

        Debug.LogError("[RandomAnimationList] 활성화된 캐릭터의 Animator를 찾을 수 없습니다!");
    }

    private void LoadTrainingData()
    {
        availableTrainings.Clear();

        var loadedTrainings = Resources.LoadAll<TrainingData>(trainingDataPath);
        if (loadedTrainings == null || loadedTrainings.Length == 0)
        {
            Debug.LogError($"[RandomAnimationList] '{trainingDataPath}' 경로에서 TrainingData를 찾을 수 없습니다!");
            return;
        }

        availableTrainings.AddRange(loadedTrainings);
        Debug.Log($"[RandomAnimationList] {availableTrainings.Count}개의 트레이닝 데이터 로드 완료");
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
            Debug.LogError("[RandomAnimationList] 사용 가능한 트레이닝 데이터가 없습니다!");
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
            Debug.LogWarning("[RandomAnimationList] 이미 트레이닝이 진행 중입니다.");
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
            Debug.Log("[RandomAnimationList] 트레이닝이 취소되었습니다.");
        }
        catch (Exception ex)
        {
            Debug.LogError($"[RandomAnimationList] 트레이닝 중 오류 발생: {ex}");
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

    // 진행 상황 확인용 메서드들
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
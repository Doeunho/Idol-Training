using UnityEngine;
using System.Collections.Generic;
using UnityEngine.UI;
using Cysharp.Threading.Tasks;
using System;
using System.Threading;
using System.Linq;

public class RandomAnimationList : MonoBehaviour
{
    [SerializeField] private Animator characterAnimator;
    [SerializeField] private List<TrainingData> selectedExercises = new();  // SerializeField �߰� �� �ʱ�ȭ
    private CancellationTokenSource cts;
    private const string TRAINING_DATA_PATH = "Training";

    private void Awake()
    {
        characterAnimator = GetComponentInChildren<Animator>();

        if (characterAnimator == null)
        {
            Debug.LogError("Ȱ��ȭ�� ĳ������ Animator ������Ʈ�� ã�� �� �����ϴ�!");
            return;
        }
    }

    private void OnDestroy()
    {
        if (cts != null)
        {
            cts.Cancel();
            cts.Dispose();
            cts = null;
        }
    }

    public void StartTraining()
    {
        StartTrainingSequence().Forget();
    }

    private async UniTaskVoid StartTrainingSequence()
    {
        try
        {
            if (cts != null)
            {
                cts.Cancel();
                cts.Dispose();
            }

            cts = new CancellationTokenSource();

            SelectRandomExercises();

            foreach (var exercise in selectedExercises)
            {
                await PlayExercise(exercise, cts.Token);
            }

            Debug.Log("Ʈ���̴� ������ �Ϸ�!");
        }
        catch (OperationCanceledException)
        {
            Debug.Log("Ʈ���̴��� ��ҵǾ����ϴ�.");
        }
        catch (Exception ex)
        {
            Debug.LogError($"Ʈ���̴� �� ���� �߻�: {ex}");
        }
    }

    [ContextMenu("���� � ����")] // �ν����Ϳ��� �׽�Ʈ�� �� �ֵ��� ���ؽ�Ʈ �޴� �߰�
    private void SelectRandomExercises()
    {
        selectedExercises.Clear();

        TrainingData[] allExercises = Resources.LoadAll<TrainingData>(TRAINING_DATA_PATH);

        if (allExercises == null || allExercises.Length == 0)
        {
            Debug.LogError($"'{TRAINING_DATA_PATH}' ��ο��� TrainingData�� ã�� �� �����ϴ�!");
            return;
        }

        // ���� ����Ʈ�� ����
        List<TrainingData> shuffledExercises = allExercises.OrderBy(x => UnityEngine.Random.value).ToList();

        // �տ��� 3�� ����
        selectedExercises.AddRange(shuffledExercises.Take(3));

        Debug.Log($"���õ� �: {string.Join(", ", selectedExercises.Select(x => x.trainingName))}");
    }

    private async UniTask PlayExercise(TrainingData exercise, CancellationToken cancellationToken)
    {
        characterAnimator.runtimeAnimatorController = exercise.trainingController;
        characterAnimator.SetTrigger(exercise.trainingName);

        float animationLength = GetAnimationLength(exercise.trainingName);
        await UniTask.Delay(TimeSpan.FromSeconds(animationLength), cancellationToken: cancellationToken);
    }

    private float GetAnimationLength(string animationName)
    {
        AnimatorClipInfo[] clipInfo = characterAnimator.GetCurrentAnimatorClipInfo(0);
        if (clipInfo.Length > 0)
        {
            return clipInfo[0].clip.length;
        }

        return 3f;
    }
}
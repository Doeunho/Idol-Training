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
    [SerializeField] private List<TrainingData> selectedExercises = new();  // SerializeField 추가 및 초기화
    private CancellationTokenSource cts;
    private const string TRAINING_DATA_PATH = "Training";

    private void Awake()
    {
        characterAnimator = GetComponentInChildren<Animator>();

        if (characterAnimator == null)
        {
            Debug.LogError("활성화된 캐릭터의 Animator 컴포넌트를 찾을 수 없습니다!");
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

            Debug.Log("트레이닝 시퀀스 완료!");
        }
        catch (OperationCanceledException)
        {
            Debug.Log("트레이닝이 취소되었습니다.");
        }
        catch (Exception ex)
        {
            Debug.LogError($"트레이닝 중 오류 발생: {ex}");
        }
    }

    [ContextMenu("랜덤 운동 선택")] // 인스펙터에서 테스트할 수 있도록 컨텍스트 메뉴 추가
    private void SelectRandomExercises()
    {
        selectedExercises.Clear();

        TrainingData[] allExercises = Resources.LoadAll<TrainingData>(TRAINING_DATA_PATH);

        if (allExercises == null || allExercises.Length == 0)
        {
            Debug.LogError($"'{TRAINING_DATA_PATH}' 경로에서 TrainingData를 찾을 수 없습니다!");
            return;
        }

        // 에셋 리스트를 섞음
        List<TrainingData> shuffledExercises = allExercises.OrderBy(x => UnityEngine.Random.value).ToList();

        // 앞에서 3개 선택
        selectedExercises.AddRange(shuffledExercises.Take(3));

        Debug.Log($"선택된 운동: {string.Join(", ", selectedExercises.Select(x => x.trainingName))}");
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
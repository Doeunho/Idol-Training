using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class TrainingDataManager : MonoBehaviour
{
    [Header("Training Settings")]
    [SerializeField] private string trainingDataPath = "Training";
    [SerializeField] private string stretch1Name = "Stretch 1";
    [SerializeField] private string stretch2Name = "Stretch 2";

    private List<TrainingData> availableTrainings = new List<TrainingData>();
    private List<List<TrainingData>> exerciseSets = new List<List<TrainingData>>();  // 3세트
    private List<TrainingData> allExercisesInOrder = new List<TrainingData>();  // UI 표시 및 재생 순서

    private bool IsPairExercise(string trainingName)
    {
        return trainingName.EndsWith("_L") || trainingName.EndsWith("_R");
    }

    private string GetPairName(string trainingName)
    {
        if (trainingName.EndsWith("_L"))
            return trainingName.Replace("_L", "_R");
        else if (trainingName.EndsWith("_R"))
            return trainingName.Replace("_R", "_L");
        return null;
    }

    private TrainingData FindPairExercise(TrainingData exercise)
    {
        if (!IsPairExercise(exercise.trainingName))
            return null;

        string pairName = GetPairName(exercise.trainingName);
        return availableTrainings.Find(x => x.trainingName == pairName);
    }

    public void LoadAndSelectRandomExercises()
    {
        LoadTrainingData();
        CreateExerciseSets();
        OrganizeExercisesInOrder();
    }

    private void LoadTrainingData()
    {
        availableTrainings.Clear();
        TrainingData[] loadedTrainings = Resources.LoadAll<TrainingData>(trainingDataPath);

        if (loadedTrainings == null || loadedTrainings.Length == 0)
        {
            Debug.LogError($"'{trainingDataPath}' 경로에서 TrainingData를 찾을 수 없습니다!");
            return;
        }

        availableTrainings.AddRange(loadedTrainings.Where(x =>
            x.trainingName != stretch1Name && x.trainingName != stretch2Name));

        Debug.Log($"로드된 트레이닝 데이터 수: {availableTrainings.Count}");
    }

    private void CreateExerciseSets()
    {
        exerciseSets.Clear();
        HashSet<string> usedExercises = new HashSet<string>();

        // 3세트 생성
        for (int setIndex = 0; setIndex < 3; setIndex++)
        {
            List<TrainingData> currentSet = new List<TrainingData>();

            // 이번 세트에서 사용 가능한 운동 풀 생성
            var availableForSet = availableTrainings
                .Where(x => !usedExercises.Contains(x.trainingName))
                .OrderBy(x => UnityEngine.Random.value)
                .ToList();

            int pairCount = 0;
            // 세트당 3개의 운동 선택 (페어 포함시 더 많아질 수 있음)
            while (currentSet.Count < 3 + pairCount && availableForSet.Any())
            {
                var exercise = availableForSet[0];
                availableForSet.RemoveAt(0);

                if (usedExercises.Contains(exercise.trainingName))
                    continue;

                currentSet.Add(exercise);
                usedExercises.Add(exercise.trainingName);

                // 페어 운동 처리
                if (IsPairExercise(exercise.trainingName))
                {
                    var pairExercise = FindPairExercise(exercise);
                    if (pairExercise != null)
                    {
                        pairCount++;
                        currentSet.Add(pairExercise);
                        usedExercises.Add(pairExercise.trainingName);
                    }
                }
            }

            exerciseSets.Add(currentSet);
            Debug.Log($"세트 {setIndex + 1} 생성 완료 (운동 수: {currentSet.Count})");
        }

        // 디버그 로그
        for (int i = 0; i < exerciseSets.Count; i++)
        {
            Debug.Log($"=== 세트 {i + 1} ({exerciseSets[i].Count}개 운동) ===");
            foreach (var exercise in exerciseSets[i])
            {
                Debug.Log($"운동: {exercise.trainingName}");
            }
        }
    }

    private void OrganizeExercisesInOrder()
    {
        allExercisesInOrder.Clear();

        // 1. Stretch 1 추가
        var stretch1 = Resources.LoadAll<TrainingData>(trainingDataPath)
            .FirstOrDefault(x => x.trainingName == stretch1Name);
        if (stretch1 != null)
            allExercisesInOrder.Add(stretch1);

        // 2. 각 세트의 모든 운동을 순서대로 추가
        foreach (var set in exerciseSets)
        {
            allExercisesInOrder.AddRange(set);
        }

        // 3. Stretch 2 추가
        var stretch2 = Resources.LoadAll<TrainingData>(trainingDataPath)
            .FirstOrDefault(x => x.trainingName == stretch2Name);
        if (stretch2 != null)
            allExercisesInOrder.Add(stretch2);

        // 디버그 로그
        Debug.Log($"=== 전체 운동 순서 (총 {allExercisesInOrder.Count}개) ===");
        for (int i = 0; i < allExercisesInOrder.Count; i++)
        {
            Debug.Log($"{i + 1}번째: {allExercisesInOrder[i].trainingName}");
        }
    }

    public List<TrainingData> GetAllExercisesInOrder()
    {
        return allExercisesInOrder;
    }

    public List<List<TrainingData>> GetExerciseSets()
    {
        return exerciseSets;
    }
}
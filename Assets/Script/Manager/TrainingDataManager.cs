using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class TrainingDataManager : MonoBehaviour
{
    [Header("Training Settings")]
    [SerializeField, Tooltip("Resources 폴더 내의 TrainingData 경로")]
    private string trainingDataPath = "Training";
    [SerializeField] private int exercisesPerSet = 3;
    [SerializeField] private int totalSets = 3;

    private List<List<TrainingData>> exerciseSets = new List<List<TrainingData>>();
    private List<TrainingData> availableTrainings = new List<TrainingData>();

    public void LoadAndSelectRandomExercises()
    {
        LoadTrainingData();
        SelectRandomExercises();
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

        availableTrainings.AddRange(loadedTrainings);
        Debug.Log($"로드된 트레이닝 데이터 수: {availableTrainings.Count}");
    }

    private void SelectRandomExercises()
    {
        exerciseSets.Clear();

        // 전체 트레이닝 데이터를 랜덤으로 섞기
        List<TrainingData> shuffledTrainings = availableTrainings
            .OrderBy(x => Random.value)
            .ToList();

        // 3세트로 나누기
        for (int i = 0; i < totalSets; i++)
        {
            List<TrainingData> setExercises = new List<TrainingData>();

            // 각 세트당 3개의 운동 선택
            int startIndex = i * exercisesPerSet;
            for (int j = 0; j < exercisesPerSet && startIndex + j < shuffledTrainings.Count; j++)
            {
                setExercises.Add(shuffledTrainings[startIndex + j]);
            }

            exerciseSets.Add(setExercises);
        }

        // 디버그 로그
        PrintSelectedExercises();
    }

    private void PrintSelectedExercises()
    {
        for (int i = 0; i < exerciseSets.Count; i++)
        {
            Debug.Log($"=== 세트 {i + 1} ===");
            foreach (var exercise in exerciseSets[i])
            {
                Debug.Log($"운동: {exercise.exerciseName} (타입: {exercise.exerciseType})");
            }
        }
    }

    public List<List<TrainingData>> GetExerciseSets()
    {
        return exerciseSets;
    }

    public List<TrainingData> GetSetExercises(int setIndex)
    {
        if (setIndex >= 0 && setIndex < exerciseSets.Count)
        {
            return exerciseSets[setIndex];
        }
        return null;
    }

    public List<TrainingData> GetAllExercisesFlattened()
    {
        return exerciseSets.SelectMany(set => set).ToList();
    }
}
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class TrainingDataManager : MonoBehaviour
{
    [Header("Training Settings")]
    [SerializeField, Tooltip("Resources ���� ���� TrainingData ���")]
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
            Debug.LogError($"'{trainingDataPath}' ��ο��� TrainingData�� ã�� �� �����ϴ�!");
            return;
        }

        availableTrainings.AddRange(loadedTrainings);
        Debug.Log($"�ε�� Ʈ���̴� ������ ��: {availableTrainings.Count}");
    }

    private void SelectRandomExercises()
    {
        exerciseSets.Clear();

        // ��ü Ʈ���̴� �����͸� �������� ����
        List<TrainingData> shuffledTrainings = availableTrainings
            .OrderBy(x => Random.value)
            .ToList();

        // 3��Ʈ�� ������
        for (int i = 0; i < totalSets; i++)
        {
            List<TrainingData> setExercises = new List<TrainingData>();

            // �� ��Ʈ�� 3���� � ����
            int startIndex = i * exercisesPerSet;
            for (int j = 0; j < exercisesPerSet && startIndex + j < shuffledTrainings.Count; j++)
            {
                setExercises.Add(shuffledTrainings[startIndex + j]);
            }

            exerciseSets.Add(setExercises);
        }

        // ����� �α�
        PrintSelectedExercises();
    }

    private void PrintSelectedExercises()
    {
        for (int i = 0; i < exerciseSets.Count; i++)
        {
            Debug.Log($"=== ��Ʈ {i + 1} ===");
            foreach (var exercise in exerciseSets[i])
            {
                Debug.Log($"�: {exercise.exerciseName} (Ÿ��: {exercise.exerciseType})");
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
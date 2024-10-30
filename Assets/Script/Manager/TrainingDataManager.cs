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
    private List<List<TrainingData>> exerciseSets = new List<List<TrainingData>>();  // 3��Ʈ
    private List<TrainingData> allExercisesInOrder = new List<TrainingData>();  // UI ǥ�� �� ��� ����

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
            Debug.LogError($"'{trainingDataPath}' ��ο��� TrainingData�� ã�� �� �����ϴ�!");
            return;
        }

        availableTrainings.AddRange(loadedTrainings.Where(x =>
            x.trainingName != stretch1Name && x.trainingName != stretch2Name));

        Debug.Log($"�ε�� Ʈ���̴� ������ ��: {availableTrainings.Count}");
    }

    private void CreateExerciseSets()
    {
        exerciseSets.Clear();
        HashSet<string> usedExercises = new HashSet<string>();

        // 3��Ʈ ����
        for (int setIndex = 0; setIndex < 3; setIndex++)
        {
            List<TrainingData> currentSet = new List<TrainingData>();

            // �̹� ��Ʈ���� ��� ������ � Ǯ ����
            var availableForSet = availableTrainings
                .Where(x => !usedExercises.Contains(x.trainingName))
                .OrderBy(x => UnityEngine.Random.value)
                .ToList();

            int pairCount = 0;
            // ��Ʈ�� 3���� � ���� (��� ���Խ� �� ������ �� ����)
            while (currentSet.Count < 3 + pairCount && availableForSet.Any())
            {
                var exercise = availableForSet[0];
                availableForSet.RemoveAt(0);

                if (usedExercises.Contains(exercise.trainingName))
                    continue;

                currentSet.Add(exercise);
                usedExercises.Add(exercise.trainingName);

                // ��� � ó��
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
            Debug.Log($"��Ʈ {setIndex + 1} ���� �Ϸ� (� ��: {currentSet.Count})");
        }

        // ����� �α�
        for (int i = 0; i < exerciseSets.Count; i++)
        {
            Debug.Log($"=== ��Ʈ {i + 1} ({exerciseSets[i].Count}�� �) ===");
            foreach (var exercise in exerciseSets[i])
            {
                Debug.Log($"�: {exercise.trainingName}");
            }
        }
    }

    private void OrganizeExercisesInOrder()
    {
        allExercisesInOrder.Clear();

        // 1. Stretch 1 �߰�
        var stretch1 = Resources.LoadAll<TrainingData>(trainingDataPath)
            .FirstOrDefault(x => x.trainingName == stretch1Name);
        if (stretch1 != null)
            allExercisesInOrder.Add(stretch1);

        // 2. �� ��Ʈ�� ��� ��� ������� �߰�
        foreach (var set in exerciseSets)
        {
            allExercisesInOrder.AddRange(set);
        }

        // 3. Stretch 2 �߰�
        var stretch2 = Resources.LoadAll<TrainingData>(trainingDataPath)
            .FirstOrDefault(x => x.trainingName == stretch2Name);
        if (stretch2 != null)
            allExercisesInOrder.Add(stretch2);

        // ����� �α�
        Debug.Log($"=== ��ü � ���� (�� {allExercisesInOrder.Count}��) ===");
        for (int i = 0; i < allExercisesInOrder.Count; i++)
        {
            Debug.Log($"{i + 1}��°: {allExercisesInOrder[i].trainingName}");
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
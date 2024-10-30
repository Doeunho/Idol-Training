using UnityEngine;
using UnityEngine.UI;
using TMPro;
using Unity.VisualScripting;
using System.Collections.Generic;
using System.Linq;
public class TrainingListUIController : MonoBehaviour
{
    [Header("UI References")]
    [SerializeField] private GameObject programUI;
    [SerializeField] private GameObject setUI;
    [SerializeField] private Transform parentTransform;
    [SerializeField] private string setParentPath = "TrainingIcon";
    [SerializeField] private TrainingDataManager trainingDataManager;

    public void SpawnObjects()
    {
        foreach (Transform child in parentTransform)
        {
            Destroy(child.gameObject);
        }

        trainingDataManager.LoadAndSelectRandomExercises();
        CreateUIElements();
    }

    private void CreateUIElements()
    {
        var allExercises = trainingDataManager.GetAllExercisesInOrder();
        var exerciseSets = trainingDataManager.GetExerciseSets();

        // 5���� ���� ���α׷� UI ����
        // 1. Stretch 1
        CreateProgramUI(0, allExercises[0], "STRETCH 1");

        // 2-4. ��Ʈ 1-3
        for (int i = 0; i < 3; i++)
        {
            string setDescription = $"SET {i + 1} ({exerciseSets[i].Count} Exercises)";
            CreateProgramUI(i + 1, exerciseSets[i][0], setDescription);
        }

        // 5. Stretch 2
        CreateProgramUI(4, allExercises[allExercises.Count - 1], "STRETCH 2");

        // Stretch 1 UI ����
        CreateStretchUI(0, allExercises[0]);

        // ��Ʈ�� �� UI ����
        CreateSetDetails(exerciseSets);

        // Stretch 2 UI ����
        CreateStretchUI(4, allExercises[allExercises.Count - 1]);
    }


    private void CreateProgramUI(int index, TrainingData exercise, string description)
    {
        GameObject mainProgramUI = Instantiate(programUI, parentTransform);

        // ��ȣ�� ���� �ؽ�Ʈ ����
        Text[] texts = mainProgramUI.GetComponentsInChildren<Text>(true);
        foreach (Text text in texts)
        {
            if (text.gameObject.name == "Text - TrainingNumber")
            {
                text.text = (index + 1).ToString("D2");
            }
            //else if (text.gameObject.name == "Text - Instructor")
            //{
            //    text.text = $"PROGRAM.{(index + 1).ToString("D2")}";
            //}
        }

        UpdateTrainingIcons(mainProgramUI.transform.Find("TrainingIcon"), exercise);
    }

    private void CreateStretchUI(int index, TrainingData exercise)
    {
        Transform programUITransform = parentTransform.GetChild(index);
        Transform setParentTransform = programUITransform.Find(setParentPath);

        if (setParentTransform != null)
        {
            // ������ ��� �ڽ� ������Ʈ���� ����
            foreach (Transform child in setParentTransform)
            {
                Destroy(child.gameObject);
            }

            GameObject newSetObject = Instantiate(setUI, setParentTransform);

            // Img - Icon ã�Ƽ� �̹��� ������Ʈ
            Transform imgIcon = newSetObject.transform.Find("Img - Icon");
            if (imgIcon != null)
            {
                Image iconImage = imgIcon.GetComponent<Image>();
                if (iconImage != null && exercise.trainingIcon != null)
                {
                    iconImage.sprite = exercise.trainingIcon;
                }
            }

            // SET �ؽ�Ʈ ������Ʈ
            Text setText = newSetObject.GetComponentInChildren<Text>();
            if (setText != null)
            {
                setText.text = index == 0 ? "STRETCH 1" : "STRETCH 2";
            }

            // � �̸� �ؽ�Ʈ ������Ʈ
            Text exerciseNameText = newSetObject.transform.Find("Text - IconName")?.GetComponent<Text>();
            if (exerciseNameText != null)
            {
                exerciseNameText.text = exercise.exerciseName;
            }

            // UI ��ġ ����
            RectTransform setRect = newSetObject.GetComponent<RectTransform>();
            if (setRect != null)
            {
                setRect.anchoredPosition = Vector2.zero;
            }
        }
    }

    private void CreateSetDetails(List<List<TrainingData>> exerciseSets)
    {
        for (int setIndex = 0; setIndex < exerciseSets.Count; setIndex++)
        {
            var setExercises = exerciseSets[setIndex];

            Transform programUITransform = parentTransform.GetChild(setIndex + 1);
            Transform setParentTransform = programUITransform.Find(setParentPath);

            if (setParentTransform != null)
            {
                // ������ ��� �ڽ� ������Ʈ���� ����
                foreach (Transform child in setParentTransform)
                {
                    Destroy(child.gameObject);
                }

                // exerciseType���� �ߺ� üũ�� ���� HashSet ����
                HashSet<TrainingData.ExerciseType> addedExerciseTypes = new HashSet<TrainingData.ExerciseType>();

                // ���ο� SET UI ����
                for (int exerciseIndex = 0; exerciseIndex < setExercises.Count; exerciseIndex++)
                {
                    TrainingData exercise = setExercises[exerciseIndex];

                    // �̹� �ش� exerciseType�� �߰��Ǿ��ٸ� ��ŵ
                    if (addedExerciseTypes.Contains(exercise.exerciseType))
                    {
                        continue;
                    }

                    // ���ο� exerciseType�̸� HashSet�� �߰�
                    addedExerciseTypes.Add(exercise.exerciseType);

                    GameObject newSetObject = Instantiate(setUI, setParentTransform);

                    // Img - Icon ã�Ƽ� �̹��� ������Ʈ
                    Transform imgIcon = newSetObject.transform.Find("Img - Icon");
                    if (imgIcon != null)
                    {
                        Image iconImage = imgIcon.GetComponent<Image>();
                        if (iconImage != null && exercise.trainingIcon != null)
                        {
                            iconImage.sprite = exercise.trainingIcon;
                        }
                    }

                    // SET �ؽ�Ʈ ������Ʈ
                    Text setText = newSetObject.GetComponentInChildren<Text>();
                    if (setText != null)
                    {
                        setText.text = $"SET {setIndex + 1}";
                    }

                    // � �̸� �ؽ�Ʈ ������Ʈ
                    Text exerciseNameText = newSetObject.transform.Find("Text - IconName")?.GetComponent<Text>();
                    if (exerciseNameText != null)
                    {
                        exerciseNameText.text = exercise.exerciseName;
                    }

                    // UI ��ġ ����
                    RectTransform setRect = newSetObject.GetComponent<RectTransform>();
                    if (setRect != null)
                    {
                        // addedExerciseTypes.Count - 1�� ����Ͽ� ������ ����
                        float xOffset = (addedExerciseTypes.Count - 1) * (setRect.rect.width + 10);
                        setRect.anchoredPosition = new Vector2(xOffset, 0);
                    }
                }
            }
        }
    }

    private void UpdateTrainingIcons(Transform trainingIconRoot, TrainingData exerciseData)
    {
        if (trainingIconRoot == null || exerciseData == null) return;

        // �� TraIcon���� ���� Img - Icon ã��
        foreach (Transform traIcon in trainingIconRoot)
        {
            // Img - Icon�� ���� ã�Ƽ� �̹��� ����
            Transform imgIcon = traIcon.Find("Img - Icon");
            if (imgIcon != null)
            {
                Image iconImage = imgIcon.GetComponent<Image>();
                if (iconImage != null && exerciseData.trainingIcon != null)
                {
                    iconImage.sprite = exerciseData.trainingIcon;
                }
            }

            // Text - IconName ������Ʈ
            Transform textIconName = traIcon.Find("Text - IconName");
            if (textIconName != null)
            {
                Text iconText = textIconName.GetComponent<Text>();
                if (iconText != null)
                {
                    iconText.text = exerciseData.exerciseName;
                }
            }
        }
    }
}
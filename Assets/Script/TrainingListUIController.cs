using UnityEngine;
using UnityEngine.UI;
using TMPro;
using Unity.VisualScripting;
public class TrainingListUIController : MonoBehaviour
{
    [Header("UI References")]
    [SerializeField] private GameObject programUI;
    [SerializeField] private Transform parentTransform;
    [SerializeField] private TrainingDataManager trainingDataManager;

    public void SpawnObjects()
    {
        // ���� UI ��ҵ� ����
        foreach (Transform child in parentTransform)
        {
            Destroy(child.gameObject);
        }

        // � ������ �ε� �� ����
        trainingDataManager.LoadAndSelectRandomExercises();

        // UI ����
        CreateUIElements();
    }

    private void CreateUIElements()
    {
        // ��� � ������ ��������
        var allExercises = trainingDataManager.GetAllExercisesFlattened();

        for (int i = 0; i < allExercises.Count; i++)
        {
            var exercise = allExercises[i];
            GameObject newObject = Instantiate(programUI, parentTransform);

            // ��ȣ�� Instructor �ؽ�Ʈ ����
            Text[] texts = newObject.GetComponentsInChildren<Text>(true);
            int displayNumber = i + 1;

            foreach (Text text in texts)
            {
                if (text.gameObject.name == "Text - TrainingNumber")
                {
                    text.text = displayNumber.ToString("D2");
                }
                else if (text.gameObject.name == "Text - Instructor")
                {
                    text.text = $"PROGRAM.{displayNumber.ToString("D2")} INSTRUCTOR";
                }
            }

            // � ������ ����
            Image exerciseIcon = newObject.GetComponentInChildren<Image>();
            if (exerciseIcon != null && exercise.trainingIcon != null)
            {
                exerciseIcon.sprite = exercise.trainingIcon;
            }
        }
    }
}
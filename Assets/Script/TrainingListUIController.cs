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
        // 기존 UI 요소들 제거
        foreach (Transform child in parentTransform)
        {
            Destroy(child.gameObject);
        }

        // 운동 데이터 로드 및 선택
        trainingDataManager.LoadAndSelectRandomExercises();

        // UI 생성
        CreateUIElements();
    }

    private void CreateUIElements()
    {
        // 모든 운동 데이터 가져오기
        var allExercises = trainingDataManager.GetAllExercisesFlattened();

        for (int i = 0; i < allExercises.Count; i++)
        {
            var exercise = allExercises[i];
            GameObject newObject = Instantiate(programUI, parentTransform);

            // 번호와 Instructor 텍스트 설정
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

            // 운동 아이콘 설정
            Image exerciseIcon = newObject.GetComponentInChildren<Image>();
            if (exerciseIcon != null && exercise.trainingIcon != null)
            {
                exerciseIcon.sprite = exercise.trainingIcon;
            }
        }
    }
}
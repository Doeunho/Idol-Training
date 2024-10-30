using UnityEngine;
using UnityEngine.UI;
using TMPro;
using Unity.VisualScripting;
using System.Collections.Generic;
using System.Linq;
using Cysharp.Threading.Tasks;
public class TrainingListUIController : MonoBehaviour
{
    [Header("UI References")]
    [SerializeField] private GameObject programUI;
    [SerializeField] private GameObject setUI;
    [SerializeField] private Transform parentTransform;
    [SerializeField] private string setParentPath = "TrainingIcon";
    [SerializeField] private TrainingDataManager trainingDataManager;
    [SerializeField] private MusicManager musicManager;


    public async void OnSpawnButtonClick()
    {
        await SpawnObjects();
    }


    public async UniTask SpawnObjects()
    {
        // 기존 UI 오브젝트들 제거
        foreach (Transform child in parentTransform)
        {
            Destroy(child.gameObject);
        }

        if (parentTransform.parent.GetComponent<ScrollRect>() is ScrollRect scrollRect)
        {
            scrollRect.horizontalNormalizedPosition = 0f;
        }

        // MusicManager 컴포넌트 확인 및 생성
        if (musicManager == null)
        {
            musicManager = GetComponent<MusicManager>();
            if (musicManager == null)
            {
                Debug.Log("MusicManager를 찾을 수 없어 새로 생성합니다.");
                musicManager = gameObject.AddComponent<MusicManager>();
            }
        }

        trainingDataManager.LoadAndSelectRandomExercises();
        CreateUIElements();
    }

    private void CreateUIElements()
    {
        var allExercises = trainingDataManager.GetAllExercisesInOrder();
        var exerciseSets = trainingDataManager.GetExerciseSets();

        // 5개의 메인 프로그램 UI 생성
        // 1. Stretch 1 생성
        CreateProgramUI(0, allExercises[0], "STRETCH 1");

        // 2-4. 세트 1-3 생성
        for (int i = 0; i < 3; i++)
        {
            string setDescription = $"SET {i + 1} ({exerciseSets[i].Count} Exercises)";
            CreateProgramUI(i + 1, exerciseSets[i][0], setDescription);
        }

        // 5. Stretch 2 생성
        CreateProgramUI(4, allExercises[allExercises.Count - 1], "STRETCH 2");

        // 상세 UI 생성
        CreateStretchUI(0, allExercises[0]);
        CreateSetDetails(exerciseSets);
        CreateStretchUI(4, allExercises[allExercises.Count - 1]);
    }

    private void CreateProgramUI(int index, TrainingData exercise, string description)
    {
        GameObject mainProgramUI = Instantiate(programUI, parentTransform);

        // 번호와 설명 텍스트 설정
        Text[] texts = mainProgramUI.GetComponentsInChildren<Text>(true);
        foreach (Text text in texts)
        {
            if (text.gameObject.name == "Text - TrainingNumber")
            {
                text.text = (index + 1).ToString("D2");
            }
            else if (text.gameObject.name == "Text - Instructor")
            {
                text.text = $"PROGRAM.{(index + 1).ToString("D2")}";
            }
        }

        // 스트레치 운동 여부 확인 및 음악 할당
        bool isStretch = (index == 0 || index == 4);
        musicManager.AssignMusicToProgram(mainProgramUI, isStretch);

        // 트레이닝 아이콘 업데이트
        UpdateTrainingIcons(mainProgramUI.transform.Find("TrainingIcon"), exercise);

        // UI 위치 조정
        RectTransform rectTransform = mainProgramUI.GetComponent<RectTransform>();
        if (rectTransform != null)
        {
            rectTransform.anchoredPosition = new Vector2(0, -index * (rectTransform.rect.height + 10));
        }
    }

    private void CreateStretchUI(int index, TrainingData exercise)
    {
        Transform programUITransform = parentTransform.GetChild(index);
        Transform setParentTransform = programUITransform.Find(setParentPath);

        if (setParentTransform != null)
        {
            // 기존 자식 오브젝트들 제거
            foreach (Transform child in setParentTransform)
            {
                Destroy(child.gameObject);
            }

            GameObject newSetObject = Instantiate(setUI, setParentTransform);

            // 아이콘 이미지 업데이트
            Transform imgIcon = newSetObject.transform.Find("Img - Icon");
            if (imgIcon != null)
            {
                Image iconImage = imgIcon.GetComponent<Image>();
                if (iconImage != null && exercise.trainingIcon != null)
                {
                    iconImage.sprite = exercise.trainingIcon;
                }
            }

            // SET 텍스트 업데이트
            Text setText = newSetObject.GetComponentInChildren<Text>();
            if (setText != null)
            {
                setText.text = index == 0 ? "STRETCH 1" : "STRETCH 2";
            }

            // 운동 이름 텍스트 업데이트
            Text exerciseNameText = newSetObject.transform.Find("Text - IconName")?.GetComponent<Text>();
            if (exerciseNameText != null)
            {
                exerciseNameText.text = exercise.exerciseName;
            }

            // UI 위치 조정
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
                // 기존 자식 오브젝트들 제거
                foreach (Transform child in setParentTransform)
                {
                    Destroy(child.gameObject);
                }

                // exerciseType별 중복 체크를 위한 HashSet
                HashSet<TrainingData.ExerciseType> addedExerciseTypes = new HashSet<TrainingData.ExerciseType>();

                // 세트별 운동 UI 생성
                for (int exerciseIndex = 0; exerciseIndex < setExercises.Count; exerciseIndex++)
                {
                    TrainingData exercise = setExercises[exerciseIndex];

                    // 이미 추가된 운동 타입이면 스킵
                    if (addedExerciseTypes.Contains(exercise.exerciseType))
                        continue;

                    addedExerciseTypes.Add(exercise.exerciseType);
                    GameObject newSetObject = Instantiate(setUI, setParentTransform);

                    // 아이콘 이미지 업데이트
                    Transform imgIcon = newSetObject.transform.Find("Img - Icon");
                    if (imgIcon != null)
                    {
                        Image iconImage = imgIcon.GetComponent<Image>();
                        if (iconImage != null && exercise.trainingIcon != null)
                        {
                            iconImage.sprite = exercise.trainingIcon;
                        }
                    }

                    // SET 텍스트 업데이트
                    Text setText = newSetObject.GetComponentInChildren<Text>();
                    if (setText != null)
                    {
                        setText.text = $"SET {setIndex + 1}";
                    }

                    // 운동 이름 텍스트 업데이트
                    Text exerciseNameText = newSetObject.transform.Find("Text - IconName")?.GetComponent<Text>();
                    if (exerciseNameText != null)
                    {
                        exerciseNameText.text = exercise.exerciseName;
                    }

                    // UI 위치 조정 (가로 방향 간격 유지)
                    RectTransform setRect = newSetObject.GetComponent<RectTransform>();
                    if (setRect != null)
                    {
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

        foreach (Transform traIcon in trainingIconRoot)
        {
            // 아이콘 이미지 업데이트
            Transform imgIcon = traIcon.Find("Img - Icon");
            if (imgIcon != null)
            {
                Image iconImage = imgIcon.GetComponent<Image>();
                if (iconImage != null && exerciseData.trainingIcon != null)
                {
                    iconImage.sprite = exerciseData.trainingIcon;
                }
            }

            // 아이콘 이름 텍스트 업데이트
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
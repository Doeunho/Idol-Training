using UnityEngine;
using UnityEngine.UI;
using TMPro;
using Unity.VisualScripting;
public class TrainingListUIController : MonoBehaviour
{
    [SerializeField] private GameObject programUI;
    [SerializeField] private Transform parentTransform;
    [SerializeField] private Text numText;

    private void Start()
    {
        Button spawnButton = GetComponent<Button>();
        spawnButton.onClick.AddListener(SpawnObjects);
    }

    public void SpawnObjects()
    {
        int[] numbres = new int[] {1,2,3,4,5}; 

        foreach (int i in numbres)
        {
            GameObject newObject = Instantiate(programUI, parentTransform);

            RectTransform rectTransform = newObject.GetComponent<RectTransform>();
            rectTransform.anchoredPosition = new Vector2(0,0 * (i-1));

            if (numText != null)
            {
                // i+1을 두 자리 숫자 형식으로 변환 (01, 02, 03...)
                numText.text = i.ToString($"D2{i}");
            }
        }
    }
}

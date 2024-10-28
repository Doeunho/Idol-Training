using UnityEngine;
using UnityEngine.UI;
using TMPro;
using Unity.VisualScripting;
public class TrainingListUIController : MonoBehaviour
{
    [SerializeField] private GameObject programUI;
    [SerializeField] private Transform parentTransform;

    public void SpawnObjects()
    {
        int[] numbers = new int[] { 1, 2, 3, 4, 5 };
        foreach (int i in numbers)
        {
            GameObject newObject = Instantiate(programUI, parentTransform);
            RectTransform rectTransform = newObject.GetComponent<RectTransform>();
            rectTransform.anchoredPosition = new Vector2(0, 0 * (i - 1));

            Text[] texts = newObject.GetComponentsInChildren<Text>(true);
            foreach (Text text in texts)
            {
                if (text.gameObject.name == "Text - TrainingNumber")
                {
                    text.text = i.ToString("D2");
                }
            }

            Text[] tmpTexts = newObject.GetComponentsInChildren<Text>(true);
            foreach (Text text in tmpTexts)
            {
                if (text.gameObject.name == "Text - Instructor")
                {
                    text.text = $"PROGRAM.{i.ToString("D2")} INSTRUCTOR";
                }
            }
        }
    }
}
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using Unity.VisualScripting;
public class TrainingListUIController : MonoBehaviour
{
    [SerializeField] private GameObject programUI;
    [SerializeField] private Transform parentTransform;

    private void Start()
    {
        Button spawnButton = GetComponent<Button>();

        spawnButton.onClick.AddListener(SpawnObjects);
    }

    private void SpawnObjects()
    {
        for (int i = 0; i < 5; i++)
        {
            GameObject newObject = Instantiate(programUI, parentTransform);

            RectTransform rectTransform = newObject.GetComponent<RectTransform>();
            rectTransform.anchoredPosition = new Vector2(0,-100 * i);
        }
    }
}

using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using System.Collections;
using DG.Tweening;

public class TextTyping : MonoBehaviour, IPointerClickHandler
{
    public Text uiText; // 텍스트 UI 요소
    public string fullText; // 표시할 전체 텍스트
    public float delay = 0.1f; // 한 글자씩 표시되는 시간 간격
    public GameObject[] targetObjects; // 활성화/비활성화할 오브젝트 배열

    private bool isTypingComplete = false;

    private void Start()
    {
        uiText.text = "";
        StartTyping();
    }

    public void OnPointerClick(PointerEventData eventData)
    {
        if (isTypingComplete)
        {
            ToggleTargetObjects(); // 오브젝트의 활성화 상태를 토글
        }
    }

    public void StartTyping()
    {
        StartCoroutine(TypeText());
    }

    private IEnumerator TypeText()
    {
        uiText.text = "";
        isTypingComplete = false;
        foreach (char letter in fullText.ToCharArray())
        {
            uiText.text += letter;
            yield return new WaitForSeconds(delay);
        }
        isTypingComplete = true;
    }

    private void ToggleTargetObjects()
    {
        foreach (GameObject obj in targetObjects)
        {
            obj.SetActive(!obj.activeSelf); // 각 오브젝트의 활성화 상태를 토글
        }
    }
}

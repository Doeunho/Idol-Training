using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using System.Collections;
using DG.Tweening;

public class TextTyping : MonoBehaviour, IPointerClickHandler
{
    public Text uiText; // �ؽ�Ʈ UI ���
    public string fullText; // ǥ���� ��ü �ؽ�Ʈ
    public float delay = 0.1f; // �� ���ھ� ǥ�õǴ� �ð� ����
    public GameObject[] targetObjects; // Ȱ��ȭ/��Ȱ��ȭ�� ������Ʈ �迭

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
            ToggleTargetObjects(); // ������Ʈ�� Ȱ��ȭ ���¸� ���
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
            obj.SetActive(!obj.activeSelf); // �� ������Ʈ�� Ȱ��ȭ ���¸� ���
        }
    }
}

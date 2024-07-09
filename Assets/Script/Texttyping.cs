using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class Texttyping : MonoBehaviour, IPointerClickHandler
{
    [Header("ConversationTrainingEndRoot")]
    [SerializeField] GameObject ConversationTrainingEndRoot1;
    [SerializeField] GameObject ConversationTrainingEndRoot2;
    [SerializeField] GameObject ConversationTrainingEndRoot3;
    [SerializeField] GameObject ConversationTrainingEndRoot4;
    [SerializeField] GameObject ConversationTrainingEndRoot5;

    public Text uiText; // UI �ؽ�Ʈ ������Ʈ
    public string[] sentences; // ���� �迭
    public float typingSpeed = 0.1f; // Ÿ���� �ӵ�

    private int currentSentenceIndex = 0;
    private bool isTyping = false;




    void Start()
    {
        // ù ��° ���������� ������ �� ������ ����ϵ��� �մϴ�.
        ShowNextSentence();
    }

    public void OnPointerClick(PointerEventData eventData)
    {
        // ��ȭâ�� Ŭ���Ǿ��� �� ���� ���� ���
        if (!isTyping)
        {
            ShowNextSentence();
        }
    }

    public void ShowNextSentence()
    {
        if (currentSentenceIndex < sentences.Length && !isTyping)
        {
            StartCoroutine(ShowText(sentences[currentSentenceIndex]));
            currentSentenceIndex++;
        }
    }

    IEnumerator ShowText(string fullText)
    {
        isTyping = true;
        string currentText = "";

        for (int i = 0; i <= fullText.Length; i++)
        {
            currentText = fullText.Substring(0, i);
            uiText.text = currentText;
            yield return new WaitForSeconds(typingSpeed);
        }

        isTyping = false;
    }

    // �� �޼���� �� ���������� ���� �� ȣ��Ǿ�� �մϴ�.
    public void OnStageEnd()
    {
        ShowNextSentence();
    }

    public void OnStageCompleted()
    {
        // TextTyping ��ũ��Ʈ�� OnStageEnd �޼��带 ȣ���Ͽ� ���� ������ ����մϴ�.
        FindObjectOfType<Texttyping>().OnStageEnd();
    }
}

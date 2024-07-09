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

    public Text uiText; // UI 텍스트 컴포넌트
    public string[] sentences; // 문장 배열
    public float typingSpeed = 0.1f; // 타이핑 속도

    private int currentSentenceIndex = 0;
    private bool isTyping = false;




    void Start()
    {
        // 첫 번째 스테이지가 끝났을 때 문장을 출력하도록 합니다.
        ShowNextSentence();
    }

    public void OnPointerClick(PointerEventData eventData)
    {
        // 대화창이 클릭되었을 때 다음 문장 출력
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

    // 이 메서드는 각 스테이지가 끝날 때 호출되어야 합니다.
    public void OnStageEnd()
    {
        ShowNextSentence();
    }

    public void OnStageCompleted()
    {
        // TextTyping 스크립트의 OnStageEnd 메서드를 호출하여 다음 문장을 출력합니다.
        FindObjectOfType<Texttyping>().OnStageEnd();
    }
}

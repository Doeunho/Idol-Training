using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Texttyping : MonoBehaviour
{
    public Text uiText; // UI �ؽ�Ʈ ������Ʈ
    public string[] sentences; // ���� �迭
    public float typingSpeed = 0.1f; // Ÿ���� �ӵ�

    private string currentText = "";

    void Start()
    {
        string randomSentence = GetRandomSentence();
        StartCoroutine(ShowText(randomSentence));
    }

    string GetRandomSentence()
    {
        int randomIndex = Random.Range(0, sentences.Length);
        return sentences[randomIndex];
    }

    IEnumerator ShowText(string fullText)
    {
        for (int i = 0; i <= fullText.Length; i++)
        {
            currentText = fullText.Substring(0, i);
            uiText.text = currentText;
            yield return new WaitForSeconds(typingSpeed);
        }
    }
}

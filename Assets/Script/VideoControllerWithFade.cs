using System.Collections;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Video;

public class VideoControllerWithFade : MonoBehaviour
{
    public AudioSource audioSource; // ����� �ҽ�
    public Button fadeOutButton; // ���̵� �ƿ� ��ư
    public float fadeDuration;// ���̵� �ƿ� �ð�

    void Start()
    {
        if (fadeOutButton != null)
        {
            fadeOutButton.onClick.AddListener(FadeOutAudio);
        }
    }

    public void FadeOutAudio()
    {
        StartCoroutine(FadeOutCoroutine());
    }

    private IEnumerator FadeOutCoroutine()
    {
        float startVolume = audioSource.volume;

        for (float t = 0; t < fadeDuration; t += Time.deltaTime)
        {
            audioSource.volume = Mathf.Lerp(startVolume, 0, t / fadeDuration);
            yield return null;
        }

        audioSource.volume = 0;
        audioSource.Stop();
    }
}

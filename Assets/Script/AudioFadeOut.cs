using UnityEngine;
using System.Collections;

public class AudioFadeOut : MonoBehaviour
{
    public AudioSource audioSource;    // ����� �ҽ� ������Ʈ
    public float timerDuration = 10.0f;  // Ÿ�̸� ���� �ð� (��)
    public float fadeOutDuration = 5.0f; // ���̵� �ƿ� ���� �ð� (��)

    private float timeRemaining; // Ÿ�̸� ���� �ð�

    void Start()
    {
        if (audioSource == null)
        {
            Debug.LogError("AudioSource ������Ʈ�� �Ҵ���� �ʾҽ��ϴ�.");
            return;
        }

        timeRemaining = timerDuration;
        StartCoroutine(TimerCountdown());
    }

    IEnumerator TimerCountdown()
    {
        while (timeRemaining > 0)
        {
            timeRemaining -= Time.deltaTime;
            yield return null;
        }

        // Ÿ�̸Ӱ� ������ ���̵� �ƿ� ����
        StartCoroutine(FadeOutAudio());
    }

    IEnumerator FadeOutAudio()
    {
        float startVolume = audioSource.volume;

        while (audioSource.volume > 0)
        {
            audioSource.volume -= startVolume * Time.deltaTime / fadeOutDuration;
            yield return null;
        }

        audioSource.Stop(); // ����� ��� ����
        audioSource.volume = startVolume; // ���� ����� ���� ���� ����
    }
}

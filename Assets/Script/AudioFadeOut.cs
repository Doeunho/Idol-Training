using UnityEngine;
using System.Collections;

public class AudioFadeOut : MonoBehaviour
{
    public AudioSource audioSource;    // 오디오 소스 컴포넌트
    public float timerDuration = 10.0f;  // 타이머 지속 시간 (초)
    public float fadeOutDuration = 5.0f; // 페이드 아웃 지속 시간 (초)

    private float timeRemaining; // 타이머 남은 시간

    void Start()
    {
        if (audioSource == null)
        {
            Debug.LogError("AudioSource 컴포넌트가 할당되지 않았습니다.");
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

        // 타이머가 끝나면 페이드 아웃 시작
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

        audioSource.Stop(); // 오디오 재생 정지
        audioSource.volume = startVolume; // 다음 재생을 위해 볼륨 복원
    }
}

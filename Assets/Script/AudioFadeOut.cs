using UnityEngine;
using System.Collections;
using Cysharp.Threading.Tasks;

public class AudioFadeOut : MonoBehaviour
{
    public AudioSource audioSource;
    public float timerDuration = 10.0f;
    public float fadeOutDuration = 5.0f;
    private float timeRemaining;
    private bool isFading = false;

    // 페이드 아웃 완료 이벤트
    public event System.Action OnFadeOutComplete;

    public async UniTaskVoid StartTimer()
    {
        if (isFading)
        {
            Debug.Log("이미 페이드 중입니다.");
            return;
        }

        timeRemaining = timerDuration;
        while (timeRemaining > 0)
        {
            timeRemaining -= Time.deltaTime;
            await UniTask.Yield();
        }

        FadeOutAudio().Forget();
    }

    private async UniTaskVoid FadeOutAudio()
    {
        if (audioSource == null || !audioSource.isPlaying || isFading) return;

        try
        {
            isFading = true;
            float startVolume = audioSource.volume;
            float elapsedTime = 0;

            while (elapsedTime < fadeOutDuration)
            {
                elapsedTime += Time.deltaTime;
                audioSource.volume = Mathf.Lerp(startVolume, 0, elapsedTime / fadeOutDuration);
                await UniTask.Yield();
            }

            audioSource.Stop();
            audioSource.volume = startVolume;
            Destroy(audioSource);

            // 페이드 아웃 완료 이벤트 발생
            OnFadeOutComplete?.Invoke();
        }
        finally
        {
            isFading = false;
        }
    }

    private void OnDestroy()
    {
        // 컴포넌트가 제거될 때 이벤트 리스너 제거
        OnFadeOutComplete = null;
    }
}
using Cysharp.Threading.Tasks;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.UI;

public class AudioButton : MonoBehaviour
{
    private Music musicComponent;
    private AudioFadeOut audioFadeOut;
    private AudioSource currentAudioSource;
    private bool isPlayingMusic = false;
    private bool isFading = false;

    [Header("Audio Mixer Settings")]
    [SerializeField] private AudioMixer audioMixer; // 인스펙터에서 AudioMixer 할당
    [SerializeField] private string volumeParameter = "MusicVolume"; // AudioMixer의 파라미터 이름

    // 볼륨 조절을 위한 속성
    public float Volume
    {
        get
        {
            audioMixer.GetFloat(volumeParameter, out float volumeValue);
            return Mathf.Pow(10, volumeValue / 20); // dB를 선형 값으로 변환
        }
        set
        {
            float dbValue = Mathf.Log10(Mathf.Max(0.0001f, value)) * 20; // 선형 값을 dB로 변환
            audioMixer.SetFloat(volumeParameter, dbValue);
        }
    }
    private void Start()
    {

        // 버튼에 클릭 이벤트 추가
        Button button = GetComponent<Button>();
        if (button != null)
        {
            button.onClick.AddListener(PlayMusic);
        }

        // 상위 오브젝트에서 컴포넌트들 찾기
        musicComponent = GetComponentInParent<Music>();
        audioFadeOut = GetComponentInParent<AudioFadeOut>();

        // AudioFadeOut 컴포넌트가 없다면 추가
        if (audioFadeOut == null)
        {
            audioFadeOut = musicComponent.gameObject.AddComponent<AudioFadeOut>();
        }

        if (audioMixer != null)
        {
            SetInitialVolume();
        }
        else
        {
            Debug.LogError("AudioMixer가 할당되지 않았습니다!");
        }
    }

    private void SetInitialVolume()
    {
        // PlayerPrefs에서 저장된 볼륨 값을 불러옴
        float savedVolume = PlayerPrefs.GetFloat("MusicVolume", 1f);
        Volume = savedVolume;
    }

        public void SetVolume(float volume)
    {
        Volume = volume;
        PlayerPrefs.SetFloat("MusicVolume", volume);
        PlayerPrefs.Save();
    }

    private void PlayMusic()
    {
        // 재생 중이거나 페이드 중인 경우 중복 실행 방지
        if (isPlayingMusic || isFading)
        {
            Debug.Log("이미 음악이 재생 중이거나 페이드 중입니다.");
            return;
        }

        if (musicComponent != null && musicComponent._musicData != null)
        {
            // 현재 재생 중인 오디오가 있다면 페이드 아웃
            if (currentAudioSource != null && currentAudioSource.isPlaying)
            {
                isFading = true;
                FadeOutAndPlayNew().Forget();
            }
            else
            {
                PlayNewMusic();
            }
        }
        else
        {
            Debug.LogWarning("Music 컴포넌트나 MusicData가 없습니다.");
        }
    }

    private async UniTaskVoid FadeOutAndPlayNew()
    {
        try
        {
            // 현재 재생 중인 음악 페이드 아웃
            float startVolume = currentAudioSource.volume;
            float fadeOutDuration = 1.0f; // 빠른 페이드 아웃을 위해 1초로 설정
            float elapsedTime = 0;

            while (elapsedTime < fadeOutDuration)
            {
                elapsedTime += Time.deltaTime;
                currentAudioSource.volume = Mathf.Lerp(startVolume, 0, elapsedTime / fadeOutDuration);
                await UniTask.Yield();
            }

            currentAudioSource.Stop();
            currentAudioSource.volume = startVolume;
            Destroy(currentAudioSource); // 이전 AudioSource 제거

            // 새 음악 재생
            PlayNewMusic();
        }
        finally
        {
            isFading = false;
        }
    }

    private void PlayNewMusic()
    {
        try
        {
            isPlayingMusic = true;

            // 이전 AudioSource가 있다면 제거
            if (currentAudioSource != null)
            {
                Destroy(currentAudioSource);
            }

            // 새로운 AudioSource 생성 및 설정
            currentAudioSource = musicComponent.gameObject.AddComponent<AudioSource>();
            currentAudioSource.clip = musicComponent._musicData.Music;
            currentAudioSource.volume = 1f;
            currentAudioSource.Play();

            if (audioMixer != null)
            {
                currentAudioSource.outputAudioMixerGroup = audioMixer.FindMatchingGroups("Music")[0];
            }

            currentAudioSource.Play();

            // AudioFadeOut 설정
            audioFadeOut.audioSource = currentAudioSource;
            audioFadeOut.timerDuration = 10.0f;
            audioFadeOut.fadeOutDuration = 5.0f;
            audioFadeOut.OnFadeOutComplete += HandleFadeOutComplete;

            // AudioFadeOut 타이머 시작
            audioFadeOut.StartTimer().Forget();

            Debug.Log($"음악 재생 시작: {musicComponent._musicData.name}");
        }
        catch (System.Exception e)
        {
            Debug.LogError($"음악 재생 중 오류 발생: {e.Message}");
            isPlayingMusic = false;
        }
    }

    private void HandleFadeOutComplete()
    {
        isPlayingMusic = false;
        Debug.Log("음악 재생 완료");
    }

    private void OnDestroy()
    {
        // 이벤트 구독 해제
        if (audioFadeOut != null)
        {
            audioFadeOut.OnFadeOutComplete -= HandleFadeOutComplete;
        }
    }
}
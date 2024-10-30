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
    [SerializeField] private AudioMixer audioMixer; // �ν����Ϳ��� AudioMixer �Ҵ�
    [SerializeField] private string volumeParameter = "MusicVolume"; // AudioMixer�� �Ķ���� �̸�

    // ���� ������ ���� �Ӽ�
    public float Volume
    {
        get
        {
            audioMixer.GetFloat(volumeParameter, out float volumeValue);
            return Mathf.Pow(10, volumeValue / 20); // dB�� ���� ������ ��ȯ
        }
        set
        {
            float dbValue = Mathf.Log10(Mathf.Max(0.0001f, value)) * 20; // ���� ���� dB�� ��ȯ
            audioMixer.SetFloat(volumeParameter, dbValue);
        }
    }
    private void Start()
    {

        // ��ư�� Ŭ�� �̺�Ʈ �߰�
        Button button = GetComponent<Button>();
        if (button != null)
        {
            button.onClick.AddListener(PlayMusic);
        }

        // ���� ������Ʈ���� ������Ʈ�� ã��
        musicComponent = GetComponentInParent<Music>();
        audioFadeOut = GetComponentInParent<AudioFadeOut>();

        // AudioFadeOut ������Ʈ�� ���ٸ� �߰�
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
            Debug.LogError("AudioMixer�� �Ҵ���� �ʾҽ��ϴ�!");
        }
    }

    private void SetInitialVolume()
    {
        // PlayerPrefs���� ����� ���� ���� �ҷ���
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
        // ��� ���̰ų� ���̵� ���� ��� �ߺ� ���� ����
        if (isPlayingMusic || isFading)
        {
            Debug.Log("�̹� ������ ��� ���̰ų� ���̵� ���Դϴ�.");
            return;
        }

        if (musicComponent != null && musicComponent._musicData != null)
        {
            // ���� ��� ���� ������� �ִٸ� ���̵� �ƿ�
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
            Debug.LogWarning("Music ������Ʈ�� MusicData�� �����ϴ�.");
        }
    }

    private async UniTaskVoid FadeOutAndPlayNew()
    {
        try
        {
            // ���� ��� ���� ���� ���̵� �ƿ�
            float startVolume = currentAudioSource.volume;
            float fadeOutDuration = 1.0f; // ���� ���̵� �ƿ��� ���� 1�ʷ� ����
            float elapsedTime = 0;

            while (elapsedTime < fadeOutDuration)
            {
                elapsedTime += Time.deltaTime;
                currentAudioSource.volume = Mathf.Lerp(startVolume, 0, elapsedTime / fadeOutDuration);
                await UniTask.Yield();
            }

            currentAudioSource.Stop();
            currentAudioSource.volume = startVolume;
            Destroy(currentAudioSource); // ���� AudioSource ����

            // �� ���� ���
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

            // ���� AudioSource�� �ִٸ� ����
            if (currentAudioSource != null)
            {
                Destroy(currentAudioSource);
            }

            // ���ο� AudioSource ���� �� ����
            currentAudioSource = musicComponent.gameObject.AddComponent<AudioSource>();
            currentAudioSource.clip = musicComponent._musicData.Music;
            currentAudioSource.volume = 1f;
            currentAudioSource.Play();

            if (audioMixer != null)
            {
                currentAudioSource.outputAudioMixerGroup = audioMixer.FindMatchingGroups("Music")[0];
            }

            currentAudioSource.Play();

            // AudioFadeOut ����
            audioFadeOut.audioSource = currentAudioSource;
            audioFadeOut.timerDuration = 10.0f;
            audioFadeOut.fadeOutDuration = 5.0f;
            audioFadeOut.OnFadeOutComplete += HandleFadeOutComplete;

            // AudioFadeOut Ÿ�̸� ����
            audioFadeOut.StartTimer().Forget();

            Debug.Log($"���� ��� ����: {musicComponent._musicData.name}");
        }
        catch (System.Exception e)
        {
            Debug.LogError($"���� ��� �� ���� �߻�: {e.Message}");
            isPlayingMusic = false;
        }
    }

    private void HandleFadeOutComplete()
    {
        isPlayingMusic = false;
        Debug.Log("���� ��� �Ϸ�");
    }

    private void OnDestroy()
    {
        // �̺�Ʈ ���� ����
        if (audioFadeOut != null)
        {
            audioFadeOut.OnFadeOutComplete -= HandleFadeOutComplete;
        }
    }
}
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class AudioPlayer : MonoBehaviour
{
    public static AudioPlayer instance;

    [SerializeField] Button Btn_MusicPlay;
    [SerializeField] AudioSource Audio_Source;

    [SerializeField] float fadeDuration = 1.0f;

    private void Awake()
    {
        instance = this;
    }

    public void PlayAndFadeOut()
    {
        StartCoroutine(PlayAndFadeOutCoroutine());
    }

    private IEnumerator PlayAndFadeOutCoroutine()
    {
        Audio_Source.Play();
        yield return new WaitForSeconds(25.0f); // 5ÃÊ Àç»ý

        float startVolume = Audio_Source.volume;

        for (float t = 0; t < fadeDuration; t += Time.deltaTime)
        {
            Audio_Source.volume = Mathf.Lerp(startVolume, 0, t / fadeDuration);
            yield return null;
        }

        Audio_Source.Stop();
        Audio_Source.volume = startVolume;
    }

    /*
        public void OnClick_PlayAudio()
    {
        if(Audio_Source != null)
        {
            Audio_Source.gameObject.SetActive(true);
            Audio_Source.Play();
        }
    }

    public void StopMusic()
    {
        Audio_Source.Stop();
    }
    */

}

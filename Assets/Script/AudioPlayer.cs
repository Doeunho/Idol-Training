using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class AudioPlayer : MonoBehaviour
{
    [SerializeField] Button Btn_MusicPlay;
    public AudioSource Audio_Source;

    [SerializeField] float fadeDuration = 1.0f;

    [SerializeField] MusicData MusicData;
    public string MusicName;

    Image Musicicon;

    public void PlayAndFadeOut()
    {
        StartCoroutine(PlayAndFadeOutCoroutine());
    }

    public IEnumerator PlayAndFadeOutCoroutine()
    {
        Audio_Source.Play();
        yield return new WaitForSeconds(25.0f); // 25ÃÊ Àç»ý

        float startVolume = Audio_Source.volume;

        for (float t = 0; t < fadeDuration; t += Time.deltaTime)
        {
            Audio_Source.volume = Mathf.Lerp(startVolume, 0, t / fadeDuration);
            yield return null;
        }

        Audio_Source.Stop();
        Audio_Source.volume = startVolume;
    }

}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class AudioPlayer : MonoBehaviour
{
    public static AudioPlayer instance;

    [SerializeField] Button Btn_MusicPlay;
    [SerializeField] AudioSource Audio_Source;

    private void Awake()
    {
        instance = this;
    }

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


}

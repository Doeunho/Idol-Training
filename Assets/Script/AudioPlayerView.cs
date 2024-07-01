using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioPlayerView : MonoBehaviour
{
    [SerializeField] AudioPlayer _audioPlayer;
    [SerializeField] AudioClip _audioClip;

    public void OnClick_PlayAudio()
    {
        if (_audioPlayer != null)
        {
            _audioPlayer.Audio_Source.clip = _audioClip;
            _audioPlayer.PlayAndFadeOut();
        }
    }
}

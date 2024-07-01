using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class AudioPlayerView : MonoBehaviour
{
    [SerializeField] AudioPlayer _audioPlayer;
    [SerializeField] AudioClip _audioClip;

    [SerializeField] MusicData _musicData;

    Image icon;
    Text textName;

    public void OnClick_PlayMusic()
    {
        if (_musicData.musicName == MusicData.MusicName.WaitforYou)
        {
            _musicData.Musicid
        }
    }


    public void OnClick_PlayAudio()
    {
        if (_audioPlayer != null)
        {
            _audioPlayer.Audio_Source.clip = _audioClip;
            _audioPlayer.PlayAndFadeOut();
        }
    }


}

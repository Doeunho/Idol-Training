using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ButtonClickAudio : MonoBehaviour
{
    [SerializeField] AudioSource BtnClickAudio;

    void Update()
    {

    }

    public void ButtonClick_AudioPlay()
    {
        BtnClickAudio.GetComponent<AudioSource>().Play();
    }

}

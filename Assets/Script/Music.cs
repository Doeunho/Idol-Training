using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class Music : MonoBehaviour
{
    public MusicData _musicData;
    Image icon;
    Text textName;
    void Awake()
    {
        icon = GetComponentsInChildren<Image>()[1];
        icon.sprite = _musicData.Img_MusicImg;
        Text[] text = GetComponentsInChildren<Text>();
        textName = text[0];
        textName.text = _musicData.Text_MusicName;
    }
    private void OnEnable()
    {
        textName.text = string.Format(_musicData.Text_MusicName);
    }
}
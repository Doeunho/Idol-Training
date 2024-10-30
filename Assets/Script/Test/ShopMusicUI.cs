using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ShopMusicUI : MonoBehaviour
{
    public MusicData _musicData;
    Image icon;
    Text textName;

    void Awake()
    {
        // "Text - MusicName" ������Ʈ�� Text ������Ʈ ã��
        textName = transform.Find("Text - MusicName").GetComponent<Text>();
        if (textName != null && _musicData != null)
        {
            textName.text = _musicData.Text_MusicName;
        }

        // "Img - MusicImg" ������Ʈ�� Image ������Ʈ ã��
        icon = transform.Find("Img - MusicImg").GetComponent<Image>();
        if (icon != null && _musicData != null)
        {
            icon.sprite = _musicData.Img_MusicImg;
        }
    }

    private void OnEnable()
    {
        if (textName != null && _musicData != null)
        {
            textName.text = _musicData.Text_MusicName;
        }
    }
}

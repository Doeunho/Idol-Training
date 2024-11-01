using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ShopMusicUI : MonoBehaviour
{
    public MusicData musicData;
    Image icon;
    Text textName;
    void Awake()
    {
        // 모든 Image 컴포넌트 가져오기
        Image[] images = GetComponentsInChildren<Image>();
        icon = images[2];  // 중간 이미지를 위해 인덱스 조정

        if (musicData != null)
        {
            icon.sprite = musicData.Img_MusicImg;
        }

        // Text 컴포넌트 찾기
        textName = GetComponentsInChildren<Text>()[0];
        if (textName != null && musicData != null)
        {
            textName.text = musicData.Text_MusicName;
        }
    }

    private void OnEnable()
    {
        if (textName != null && musicData != null)
        {
            textName.text = musicData.Text_MusicName;
        }
    }
}

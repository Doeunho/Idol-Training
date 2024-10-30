using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CharacterUI : MonoBehaviour
{
    public CharacterData characterData;
    Image icon;
    Text textName;
    void Awake()
    {
        // 모든 Image 컴포넌트 가져오기
        Image[] images = GetComponentsInChildren<Image>();
        icon = images[2];  // 중간 이미지를 위해 인덱스 조정

        if (characterData != null)
        {
            icon.sprite = characterData.Spt_CharacterSprite;
        }

        // Text 컴포넌트 찾기
        textName = GetComponentsInChildren<Text>()[0];
        if (textName != null && characterData != null)
        {
            textName.text = characterData.CharacterName;
        }
    }

    private void OnEnable()
    {
        if (textName != null && characterData != null)
        {
            textName.text = characterData.CharacterName;
        }
    }
}

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
        // ��� Image ������Ʈ ��������
        Image[] images = GetComponentsInChildren<Image>();
        icon = images[2];  // �߰� �̹����� ���� �ε��� ����

        if (characterData != null)
        {
            icon.sprite = characterData.Spt_CharacterSprite;
        }

        // Text ������Ʈ ã��
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

using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

public class Music : MonoBehaviour
{
    public MusicData _musicData;
    public string resourcePath = "Music"; // Inspector에서 경로 설정 가능
    Image icon;
    Text textName;

    void Awake()
    {
        MusicData[] allMusicData = Resources.LoadAll<MusicData>(resourcePath).ToArray();

        if (allMusicData != null && allMusicData.Length > 0)
        {
            _musicData = allMusicData[Random.Range(0, allMusicData.Length)];
        }

        icon = GetComponentsInChildren<Image>()[1];
        if (_musicData != null)
        {
            icon.sprite = _musicData.Img_MusicImg;

            Text[] text = GetComponentsInChildren<Text>();
            textName = text[0];
            textName.text = _musicData.Text_MusicName;
        }
    }

    private void OnEnable()
    {
        if (_musicData != null)
        {
            textName.text = string.Format(_musicData.Text_MusicName);
        }
    }
}

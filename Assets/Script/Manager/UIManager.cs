using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UIManager : MonoBehaviour
{
    public static UIManager instance;

    [SerializeField] GameObject UI_Announcement;
    [SerializeField] GameObject UI_Title;

    [SerializeField] Text Text_Stratdata;
    [SerializeField] Text Text_Enddata;

    [SerializeField] GameObject Lobby;

    void Init()
    {
        
    }


    private void Awake()
    {
        instance = this;
    }

    void Start()
    {
        
    }

    void Update()
    {
        
    }

    private void StampCardDate()
    {
        if (Text_Stratdata = null)
            return;
        //트레이닝이 끝나서 스탬프카드 UI가 활성화가 되는 동시에 날짜가 찍히게

    }


    public void OnClick_OpenLobby()
    {
        //UI_Announcement.SetActive(true);
        Lobby.SetActive(true);
        AudioPlayer.instance.StopMusic();
    }

    public void OnClick_CloseAnnouncement()
    {
        //UI_Announcement.SetActive(false);
    }

}

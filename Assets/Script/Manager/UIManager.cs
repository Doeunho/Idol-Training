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

    [Header("TEXT")]
    [SerializeField] Text Text_Stratdata;
    [SerializeField] Text Text_Enddata;

    [Header("BUTTON")]
    [SerializeField] Button Btn_TrainingRoom;
    [SerializeField] Button Btn_TrainingStr;


    [Header("Main UI")]
    [SerializeField] GameObject Lobby;
    [SerializeField] GameObject Titel;
    [SerializeField] GameObject TrainingRoom;
    [SerializeField] GameObject GameRoom;


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
        //Ʈ���̴��� ������ ������ī�� UI�� Ȱ��ȭ�� �Ǵ� ���ÿ� ��¥�� ������

    }


    public void OnClick_OpenLobby()
    {
        Lobby.SetActive(true);
        //AudioPlayer.instance.StopMusic();
    }

    public void OnClick_OpenTraRoom()
    {
        TrainingRoom.SetActive(true);
    }

}

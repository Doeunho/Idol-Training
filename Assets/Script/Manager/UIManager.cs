using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;

public class UIManager : MonoBehaviour
{
    [SerializeField] GameObject UI_Announcement;
    [SerializeField] GameObject UI_Title;

    [Header("TEXT")]
    [SerializeField] Text Text_Stratdata;
    [SerializeField] Text Text_Enddata;
    [SerializeField] Text Text_CurrentDate;

    [Header("BUTTON")]
    [SerializeField] Button Btn_TrainingRoom;
    [SerializeField] Button Btn_TrainingStr;


    [Header("Main UI")]
    public GameObject Lobby;
    public GameObject Titel;
    public GameObject TrainingRoom;
    public GameObject GameRoom;

    void Start()
    {
        PrintcurrentDate();
    }

    void Update()
    {

    }

    private void StampCardDate()
    {
        //트레이닝이 끝나서 스탬프카드 UI가 활성화가 되는 동시에 날짜가 찍히게

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

    public void PrintcurrentDate()
    {
        string currentDate = System.DateTime.Now.ToString("yyyy MM.dd");

        Text_CurrentDate.text = currentDate;

    }



}

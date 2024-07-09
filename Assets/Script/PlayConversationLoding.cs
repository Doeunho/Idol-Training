using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayConversationLoding : MonoBehaviour
{
    [SerializeField] GameObject ConversationLodingRoot1;
    [SerializeField] GameObject ConversationLodingRoot2;
    [SerializeField] GameObject ConversationLodingRoot3;
    [SerializeField] GameObject ConversationLodingRoot4;
    [SerializeField] GameObject ConversationLodingRoot5;

    [SerializeField] GameObject GameLodingRoom1;
    [SerializeField] GameObject GameLodingRoom2;
    [SerializeField] GameObject GameLodingRoom3;
    [SerializeField] GameObject GameLodingRoom4;
    [SerializeField] GameObject GameLodingRoom5;


    public void OnCilck_TrainingStart1()
    {
        GameLodingRoom1.SetActive(true);
        ConversationLodingRoot1.SetActive(true);
    }

    public void OnCilck_TrainingStart2()
    {
        GameLodingRoom2.SetActive(true);
        ConversationLodingRoot2.SetActive(true);
    }

    public void OnCilck_TrainingStart3()
    {
        GameLodingRoom3.SetActive(true);
        ConversationLodingRoot3.SetActive(true);
    }

    public void OnCilck_TrainingStart4()
    {
        GameLodingRoom4.SetActive(true);
        ConversationLodingRoot4.SetActive(true);
    }

    public void OnCilck_TrainingStart5()
    {
        GameLodingRoom5.SetActive(true);
        ConversationLodingRoot5.SetActive(true);
    }

}

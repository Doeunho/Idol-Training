using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UI_LobbyDate : MonoBehaviour
{
    [SerializeField] private Text Text_CurrentDate;

    private void Awake()
    {
        PrintcurrentDate();
    }

    private void PrintcurrentDate()
    {
        string currentDate = System.DateTime.Now.ToString("yyyy MM.dd");

        Text_CurrentDate.text = currentDate;
    }
}

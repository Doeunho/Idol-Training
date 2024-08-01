using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;

public class ButtonColorController : MonoBehaviour
{
    // 버튼과 그 원래 색상을 저장할 필드
    public Button[] buttons;
    public Color defaultColor = Color.white;
    public Color selectedColor = Color.yellow;

    private Button selectedButton = null;

    void Start()
    {
        // 각 버튼에 클릭 이벤트 추가
        foreach (Button btn in buttons)
        {
            btn.onClick.AddListener(() => OnButtonClicked(btn));
        }
    }

    void OnButtonClicked(Button clickedButton)
    {
        // 클릭한 버튼이 이미 선택된 상태인지 확인
        if (selectedButton != null)
        {
            // 선택된 버튼의 색상을 기본 색상으로 변경
            SetButtonColor(selectedButton, defaultColor);
        }

        // 클릭한 버튼을 새로운 선택된 버튼으로 설정
        selectedButton = clickedButton;

        // 선택된 버튼의 색상을 노란색으로 변경
        SetButtonColor(selectedButton, selectedColor);
    }

    public void ResetButtonColor()
    {
        if (selectedButton != null)
        {
            // 선택된 버튼의 색상을 기본 색상으로 변경하고 선택을 해제
            SetButtonColor(selectedButton, defaultColor);
            selectedButton = null;
        }
    }

    private void SetButtonColor(Button button, Color color)
    {
        // 버튼의 색상을 설정하는 함수
        ColorBlock colorBlock = button.colors;
        colorBlock.normalColor = color;
        colorBlock.selectedColor = color;
        button.colors = colorBlock;
    }
}
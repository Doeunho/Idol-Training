using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;

public class ButtonColorController : MonoBehaviour
{
    // ��ư�� �� ���� ������ ������ �ʵ�
    public Button[] buttons;
    public Color defaultColor = Color.white;
    public Color selectedColor = Color.yellow;

    private Button selectedButton = null;

    void Start()
    {
        // �� ��ư�� Ŭ�� �̺�Ʈ �߰�
        foreach (Button btn in buttons)
        {
            btn.onClick.AddListener(() => OnButtonClicked(btn));
        }
    }

    void OnButtonClicked(Button clickedButton)
    {
        // Ŭ���� ��ư�� �̹� ���õ� �������� Ȯ��
        if (selectedButton != null)
        {
            // ���õ� ��ư�� ������ �⺻ �������� ����
            SetButtonColor(selectedButton, defaultColor);
        }

        // Ŭ���� ��ư�� ���ο� ���õ� ��ư���� ����
        selectedButton = clickedButton;

        // ���õ� ��ư�� ������ ��������� ����
        SetButtonColor(selectedButton, selectedColor);
    }

    public void ResetButtonColor()
    {
        if (selectedButton != null)
        {
            // ���õ� ��ư�� ������ �⺻ �������� �����ϰ� ������ ����
            SetButtonColor(selectedButton, defaultColor);
            selectedButton = null;
        }
    }

    private void SetButtonColor(Button button, Color color)
    {
        // ��ư�� ������ �����ϴ� �Լ�
        ColorBlock colorBlock = button.colors;
        colorBlock.normalColor = color;
        colorBlock.selectedColor = color;
        button.colors = colorBlock;
    }
}
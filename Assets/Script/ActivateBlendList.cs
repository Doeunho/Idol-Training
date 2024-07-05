using UnityEngine;
using Cinemachine;
using UnityEngine.UI;
using System.Collections;
using Unity.VisualScripting;

public class ActivateBlendList : MonoBehaviour
{
    public CinemachineBlendListCamera blendListCamera; // Blend List Camera ����
    public Button activateButton;                      // ��ư ����
    public Animator characterAnimator;                 // ĳ������ Animator
    public string animationTrigger;                    // ����� �ִϸ��̼� Ʈ���� �̸�

    public float delay;

    public GameObject targetObject;

    /*
    void Start()
    {
        // ��ư Ŭ�� �̺�Ʈ�� �޼��� ���
        if (activateButton != null)
        {
            activateButton.onClick.AddListener(ActivateCameraAndAnimation);
        }

        // ��ư Ŭ�� �̺�Ʈ�� �޼��� ���
        if (activateButton != null)
        {
            activateButton.onClick.AddListener(OnButtonClick);
        }

    }
    */

    public void OnButtonClick()
    {
        // �ڷ�ƾ ����
        StartCoroutine(ActivateObject());
    }

    IEnumerator ActivateObject()
    {
        // ���� �ð���ŭ ���
        yield return new WaitForSeconds(delay);

        // Ÿ�� ������Ʈ Ȱ��ȭ
        targetObject.SetActive(true);
    }

    public void ActivateCameraAndAnimation()
    {
        // Blend List Camera Ȱ��ȭ
        if (blendListCamera != null)
        {
            blendListCamera.Priority = 10; // �켱 ���� ������ Ȱ��ȭ
            
        }

        // �ִϸ��̼� Ʈ���� �����Ͽ� �ִϸ��̼� ���
        if (characterAnimator != null && !string.IsNullOrEmpty(animationTrigger))
        {
            characterAnimator.SetTrigger(animationTrigger);
        }
    }
}

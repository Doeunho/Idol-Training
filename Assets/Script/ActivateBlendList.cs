using UnityEngine;
using Cinemachine;
using UnityEngine.UI;
using System.Collections;
using Unity.VisualScripting;

public class ActivateBlendList : MonoBehaviour
{
    public CinemachineBlendListCamera blendListCamera; // Blend List Camera ����
    public Button activateButton;                      // ��ư ����
    public Animator Mao_characterAnimator;                 // ĳ������ Animator
    public Animator Makoto_characterAnimator;                 // ĳ������ Animator
    public Animator Hokuto_characterAnimator;                 // ĳ������ Animator

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

    public void MaoActivateCameraAndAnimation()
    {
        // Blend List Camera Ȱ��ȭ
        if (blendListCamera != null)
        {
            blendListCamera.Priority = 10; // �켱 ���� ������ Ȱ��ȭ
            
        }

        // �ִϸ��̼� Ʈ���� �����Ͽ� �ִϸ��̼� ���
        if (Mao_characterAnimator != null && !string.IsNullOrEmpty(animationTrigger))
        {
            Mao_characterAnimator.SetTrigger(animationTrigger);
        }
    }

    public void MakotoActivateCameraAndAnimation()
    {
        // Blend List Camera Ȱ��ȭ
        if (blendListCamera != null)
        {
            blendListCamera.Priority = 10; // �켱 ���� ������ Ȱ��ȭ

        }

        // �ִϸ��̼� Ʈ���� �����Ͽ� �ִϸ��̼� ���
        if (Makoto_characterAnimator != null && !string.IsNullOrEmpty(animationTrigger))
        {
            Makoto_characterAnimator.SetTrigger(animationTrigger);
        }
    }

    public void HokutoActivateCameraAndAnimation()
    {
        // Blend List Camera Ȱ��ȭ
        if (blendListCamera != null)
        {
            blendListCamera.Priority = 10; // �켱 ���� ������ Ȱ��ȭ

        }

        // �ִϸ��̼� Ʈ���� �����Ͽ� �ִϸ��̼� ���
        if (Hokuto_characterAnimator != null && !string.IsNullOrEmpty(animationTrigger))
        {
            Hokuto_characterAnimator.SetTrigger(animationTrigger);
        }
    }
}

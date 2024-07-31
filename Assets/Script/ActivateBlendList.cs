using UnityEngine;
using Cinemachine;
using UnityEngine.UI;
using System.Collections;
using Unity.VisualScripting;

public class ActivateBlendList : MonoBehaviour
{
    public CinemachineBlendListCamera blendListCamera; // Blend List Camera ����
    public CinemachineVirtualCamera initialCamera;     // �ʱ� ��ġ ī�޶� ����
    public Button activateButton;                      // ��ư ����
    public Animator Mao_characterAnimator;             // ĳ������ Animator
    public Animator Makoto_characterAnimator;          // ĳ������ Animator
    public Animator Hokuto_characterAnimator;          // ĳ������ Animator

    public string animationTrigger;                    // ����� �ִϸ��̼� Ʈ���� �̸�

    public float delay;
    public float blendDuration = 3.0f;                 // ���� ����Ʈ ī�޶� ��ȯ �ð�

    public GameObject targetObject;

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
        StartCoroutine(ActivateCameraAndAnimation(Mao_characterAnimator));
    }

    public void MakotoActivateCameraAndAnimation()
    {
        StartCoroutine(ActivateCameraAndAnimation(Makoto_characterAnimator));
    }

    public void HokutoActivateCameraAndAnimation()
    {
        StartCoroutine(ActivateCameraAndAnimation(Hokuto_characterAnimator));
    }

    private IEnumerator ActivateCameraAndAnimation(Animator characterAnimator)
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

        // ���� ����Ʈ ī�޶� ��ȯ �ð� ���� ���
        yield return new WaitForSeconds(blendDuration);

        // �ʱ� ī�޶�� �ǵ�����
        if (initialCamera != null)
        {
            blendListCamera.Priority = 5; // ���� ����Ʈ ī�޶� �켱 ���� ���߱�
            initialCamera.Priority = 10; // �ʱ� ī�޶� �켱 ���� ���̱�
        }

        // �ִϸ��̼� ���� �� �ʱ�ȭ (�ʿ��� ���)
        yield return new WaitForSeconds(2.0f); // �ִϸ��̼��� ���� �� ��� �ð� ����
        if (characterAnimator != null)
        {
            characterAnimator.ResetTrigger(animationTrigger); // Ʈ���� �ʱ�ȭ
        }
    }
}

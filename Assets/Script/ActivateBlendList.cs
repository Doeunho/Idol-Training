using UnityEngine;
using Cinemachine;
using UnityEngine.UI;
using System.Collections;
using Unity.VisualScripting;
using Cysharp.Threading.Tasks;

public class ActivateBlendList : MonoBehaviour
{
    public CinemachineBlendListCamera blendListCamera; // Blend List Camera ����
    public CinemachineVirtualCamera initialCamera;     // �ʱ� ��ġ ī�޶� ����
    public Button activateButton;                      // ��ư ����
    public Animator Mao_characterAnimator;             // ĳ������ Animator
    public string animationTrigger;                    // ����� �ִϸ��̼� Ʈ���� �̸�

    public float delay;
    public float blendDuration = 3.0f;                 // ���� ����Ʈ ī�޶� ��ȯ �ð�

    public GameObject targetObject;

    public async void OnButtonClick()
    {
        await ActivateObject();
    }

    private async UniTask ActivateObject()
    {
        await UniTask.Delay((int)delay * 1000);
        targetObject.SetActive(true);
    }

    public async void MaoActivateCamera()
    {
        await ActivateCameraAndAnimation(Mao_characterAnimator);
        await ActivateObject();
    }

    private async UniTask ActivateCameraAndAnimation(Animator characterAnimator)
    {
        // Blend List Camera Ȱ��ȭ
        if (blendListCamera != null)
        {
            blendListCamera.Priority = 10;
        }

        // �ִϸ��̼� Ʈ���� ����
        if (characterAnimator != null && !string.IsNullOrEmpty(animationTrigger))
        {
            characterAnimator.SetTrigger(animationTrigger);
        }

        // ���� ����Ʈ ī�޶� ��ȯ �ð� ���
        await UniTask.Delay((int)(blendDuration));

        // �ʱ� ī�޶�� �ǵ�����
        if (initialCamera != null)
        {
            blendListCamera.Priority = 5;
            initialCamera.Priority = 10;
        }

        // �ִϸ��̼� ���� �� �ʱ�ȭ
        await UniTask.Delay(2000); // 2�� ���
        if (characterAnimator != null)
        {
            characterAnimator.ResetTrigger(animationTrigger);
        }
    }
}

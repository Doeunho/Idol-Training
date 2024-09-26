using UnityEngine;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using System;

public class UI_RewarePopup : MonoBehaviour
{
    [SerializeField] private RectTransform parentUI;
    [SerializeField] private RectTransform topUI;
    [SerializeField] private RectTransform bottomUI;
    [SerializeField] private float topUIDelay = 1f;
    [SerializeField] private float topUIAnimationDuration = 1f;
    [SerializeField] private float bottomUIDelay = 0.5f;
    [SerializeField] private float bottomUIAnimationDuration = 1f;

    private CanvasGroup topUICanvasGroup;

    private void Start()
    {
        SetupCanvasGroup();
        AnimateUIAsync().Forget();
    }

    private void SetupCanvasGroup()
    {
        topUICanvasGroup = topUI.gameObject.GetComponent<CanvasGroup>();
        if (topUICanvasGroup == null)
            topUICanvasGroup = topUI.gameObject.AddComponent<CanvasGroup>();
    }

    private async UniTaskVoid AnimateUIAsync()
    {
        // �ʱ� ����
        topUI.gameObject.SetActive(false);
        bottomUI.gameObject.SetActive(false);
        topUICanvasGroup.alpha = 0f;

        // topUI ���� ���� ����
        Vector2 originalAnchorMin = topUI.anchorMin;
        Vector2 originalAnchorMax = topUI.anchorMax;
        Vector2 originalAnchoredPosition = topUI.anchoredPosition;
        Vector2 originalSizeDelta = topUI.sizeDelta;

        // topUI�� �߾����� ��Ŀ, �ǹ�, ��ġ ����
        topUI.anchorMin = topUI.anchorMax = new Vector2(0.5f, 0.5f);  // ��Ŀ�� �߾�����
        topUI.pivot = new Vector2(0.5f, 0.5f);  // �ǹ��� �߾�����
        topUI.anchoredPosition = Vector2.zero;  // �θ� �߾ӿ� ��ġ

        await UniTask.Delay(TimeSpan.FromSeconds(topUIDelay));
        topUI.gameObject.SetActive(true);

        // topUI �ִϸ��̼�: ���̵���
        await topUICanvasGroup.DOFade(1f, topUIAnimationDuration)
            .SetEase(Ease.InOutSine)
            .AsyncWaitForCompletion();

        // ���� ��Ŀ �� ��ġ�� ����
        topUI.anchorMin = originalAnchorMin;
        topUI.anchorMax = originalAnchorMax;
        topUI.anchoredPosition = originalAnchoredPosition;
        topUI.sizeDelta = originalSizeDelta;

        await UniTask.Delay(TimeSpan.FromSeconds(bottomUIDelay));
        bottomUI.gameObject.SetActive(true);

        // bottomUI ����
        bottomUI.anchorMin = new Vector2(0, 1);
        bottomUI.anchorMax = new Vector2(1, 1);
        bottomUI.pivot = new Vector2(0.5f, 1f);

        float topUIBottom = topUI.anchoredPosition.y - topUI.rect.height;
        bottomUI.anchoredPosition = new Vector2(0, topUIBottom);
        bottomUI.SetSizeWithCurrentAnchors(RectTransform.Axis.Horizontal, topUI.rect.width);

        // bottomUI �ʱ� ũ�� ���� (���̸� 0����)
        float originalHeight = bottomUI.rect.height;
        bottomUI.SetSizeWithCurrentAnchors(RectTransform.Axis.Vertical, 0);

        // bottomUI �ִϸ��̼�: ������ �Ʒ��� ��������
        await bottomUI.DOSizeDelta(new Vector2(bottomUI.sizeDelta.x, originalHeight), bottomUIAnimationDuration)
            .SetEase(Ease.OutBack)
            .AsyncWaitForCompletion();
    }
}
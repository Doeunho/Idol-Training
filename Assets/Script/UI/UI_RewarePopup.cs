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
        // 초기 설정
        topUI.gameObject.SetActive(false);
        bottomUI.gameObject.SetActive(false);
        topUICanvasGroup.alpha = 0f;

        // topUI 원래 설정 저장
        Vector2 originalAnchorMin = topUI.anchorMin;
        Vector2 originalAnchorMax = topUI.anchorMax;
        Vector2 originalAnchoredPosition = topUI.anchoredPosition;
        Vector2 originalSizeDelta = topUI.sizeDelta;

        // topUI의 중앙으로 앵커, 피벗, 위치 조정
        topUI.anchorMin = topUI.anchorMax = new Vector2(0.5f, 0.5f);  // 앵커를 중앙으로
        topUI.pivot = new Vector2(0.5f, 0.5f);  // 피벗을 중앙으로
        topUI.anchoredPosition = Vector2.zero;  // 부모 중앙에 위치

        await UniTask.Delay(TimeSpan.FromSeconds(topUIDelay));
        topUI.gameObject.SetActive(true);

        // topUI 애니메이션: 페이드인
        await topUICanvasGroup.DOFade(1f, topUIAnimationDuration)
            .SetEase(Ease.InOutSine)
            .AsyncWaitForCompletion();

        // 원래 앵커 및 위치로 복원
        topUI.anchorMin = originalAnchorMin;
        topUI.anchorMax = originalAnchorMax;
        topUI.anchoredPosition = originalAnchoredPosition;
        topUI.sizeDelta = originalSizeDelta;

        await UniTask.Delay(TimeSpan.FromSeconds(bottomUIDelay));
        bottomUI.gameObject.SetActive(true);

        // bottomUI 설정
        bottomUI.anchorMin = new Vector2(0, 1);
        bottomUI.anchorMax = new Vector2(1, 1);
        bottomUI.pivot = new Vector2(0.5f, 1f);

        float topUIBottom = topUI.anchoredPosition.y - topUI.rect.height;
        bottomUI.anchoredPosition = new Vector2(0, topUIBottom);
        bottomUI.SetSizeWithCurrentAnchors(RectTransform.Axis.Horizontal, topUI.rect.width);

        // bottomUI 초기 크기 설정 (높이를 0으로)
        float originalHeight = bottomUI.rect.height;
        bottomUI.SetSizeWithCurrentAnchors(RectTransform.Axis.Vertical, 0);

        // bottomUI 애니메이션: 위에서 아래로 펼쳐지기
        await bottomUI.DOSizeDelta(new Vector2(bottomUI.sizeDelta.x, originalHeight), bottomUIAnimationDuration)
            .SetEase(Ease.OutBack)
            .AsyncWaitForCompletion();
    }
}
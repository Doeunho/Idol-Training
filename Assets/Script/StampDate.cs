using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class StampDate : MonoBehaviour
{
    public GameObject dialogueBox;      // ��ȭâ ���� ������Ʈ
    public Animator Stampanimator;           // �ִϸ����� ������Ʈ
    public string StamptriggerName;          // Ȱ��ȭ�� �ִϸ��̼� Ʈ���� �̸�
    public GameObject StampgameObject;      // Ȱ��ȭ�� ù ��° ���� ������Ʈ
    public GameObject CardgameObject;      // Ȱ��ȭ�� �� ��° ���� ������Ʈ
    public GameObject StampCard; // �߰��� Ȱ��ȭ�� ������Ʈ1
    public GameObject Stampink; // �߰��� Ȱ��ȭ�� ������Ʈ2
    public float delayBetweenActivations; // ������Ʈ Ȱ��ȭ ���� ���� �ð�
    public float delayBetweenActivations2; // ������Ʈ Ȱ��ȭ ���� ���� �ð�


    void Update()
    {
        if (Input.GetMouseButtonDown(0)) // ���콺 ���� ��ư Ŭ�� ����
        {
            CloseDialogueAndActivateObjects();
        }

    }

    void CloseDialogueAndActivateObjects()
    {
        // ��ȭâ ��Ȱ��ȭ
        dialogueBox.SetActive(false);

        // �ִϸ��̼� Ʈ���� Ȱ��ȭ
        Stampanimator.SetTrigger(StamptriggerName);

        // ���� ������Ʈ�� ���������� Ȱ��ȭ
        StartCoroutine(ActivateObjectsInSequence());
    }

    IEnumerator ActivateObjectsInSequence()
    {
        // ù ��° ���� ������Ʈ Ȱ��ȭ
        StampgameObject.SetActive(true);
        CardgameObject.SetActive(true);
        yield return new WaitForSeconds(delayBetweenActivations);

        // �߰� ���� ������Ʈ1 Ȱ��ȭ
        if (StampCard != null)
        {
            StampCard.SetActive(true);
            Stampink.SetActive(true);
            yield return new WaitForSeconds(delayBetweenActivations);
        }
    }
}

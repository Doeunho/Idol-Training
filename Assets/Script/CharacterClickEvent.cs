using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.EventSystems;

public class CharacterClickEvent : MonoBehaviour
{
    [SerializeField] Camera _mainCamera;

    int _animCount;

    private void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            Ray ray = _mainCamera.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;

            if(Physics.Raycast(ray, out hit))
            {
                GameObject clickedObject = hit.collider.gameObject;
                if(clickedObject == null)
                {
                    return;
                }

                OnClickTargetGameObject(clickedObject);
            }
        }
    }

    private void OnClickTargetGameObject(GameObject gObj)
    {
        // gObj
        var characterAnimControl = gObj.GetComponent<CharacterAnimControll>();
        if(characterAnimControl != null)
        {
            characterAnimControl.PlaySpecificAnimation($"Idle_{_animCount}");
            _animCount++;

            _animCount = (_animCount > 2) ? 0 : _animCount;

        }
    }



    //ĳ���� Ŭ���� Idle �ִϸ��̼� �ٸ��� ������, ��絵?

    public void Click_AnimationEvent()
    {
        Debug.Log("Ŭ����");
    }
}


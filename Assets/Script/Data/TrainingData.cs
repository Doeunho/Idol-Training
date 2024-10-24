using Autodesk.Fbx;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[CreateAssetMenu(menuName = "Training Data")]
public class TrainingData : ScriptableObject
{
    [SerializeField] private string trainingName;
    [SerializeField] private RuntimeAnimatorController trainingController;
    [SerializeField] private Sprite trainingIcon;
    [SerializeField] private ExerciseType exerciseType;
    [SerializeField] private string exerciseName;

    public enum ExerciseType
    {
        Abdomen,
        Arm,
        Leg,
        Wholebody
    }
}

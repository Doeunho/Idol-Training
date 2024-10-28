using Autodesk.Fbx;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[CreateAssetMenu(menuName = "Training Data")]
public class TrainingData : ScriptableObject
{
    [SerializeField] private Sprite trainingIcon;
    [SerializeField] private ExerciseType exerciseType;
    [SerializeField] private string exerciseName;

    public string trainingName;
    public RuntimeAnimatorController trainingController;

    public enum ExerciseType
    {
        Abdomen,
        Arm,
        Leg,
        Wholebody
    }
}

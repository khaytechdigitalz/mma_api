<?php

namespace App\Http\Controllers\Customer;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ProfileController extends Controller
{
    public function showProfile(Request $request)
    {
        return response()->json([
            'status' => true,
            'message' => 'Profile fetched successfully.',
            'data' => $request->user()
        ]);
    }

    public function updateProfile(Request $request)
    {
        $customer = $request->user();

        $request->validate([
            'name' => 'required|string|max:255',
            'phone' => 'nullable|string|max:20|unique:users,phone,' . $customer->id,
            'avatar' => 'nullable|image|mimes:jpeg,png,jpg,webp|max:2048',
        ]);

        $customer->name = $request->name;
        $customer->phone = $request->phone;

        if ($request->hasFile('avatar')) {
            if ($customer->avatar && Storage::disk('public')->exists(str_replace('/storage/', '', $customer->avatar))) {
                Storage::disk('public')->delete(str_replace('/storage/app/public/', '', $customer->avatar));
            }
            $path = $request->file('avatar')->store('/app/public/avatars', 'public');
            $customer->avatar = Storage::url($path);
        }

        $customer->save();

        return response()->json([
            'status' => true,
            'message' => 'Profile updated successfully.',
            'data' => $customer
        ]);
    }

    public function listAddresses(Request $request)
    {
        return response()->json([
            'status' => true,
            'message' => 'Addresses fetched successfully.',
            'data' => $request->user()->addresses
        ]);
    }

    public function addAddress(Request $request)
    {
        $request->validate([
            'address' => 'required|string|max:255',
            'city' => 'required|string|max:100',
            'state' => 'required|string|max:100',
            'country' => 'required|string|max:100',
            'postal_code' => 'nullable|string|max:20',
            'is_default' => 'boolean',
        ]);

        $customer = $request->user();

        if ($request->boolean('is_default')) {
            $customer->addresses()->update(['is_default' => false]);
        }

        $address = $customer->addresses()->create($request->all());

        return response()->json([
            'status' => true,
            'message' => 'Address added successfully.',
            'data' => $address
        ], 201);
    }

    public function deleteAddress(Request $request, $id)
    {
        $customer = $request->user();
        $address = $customer->addresses()->where('id', $id)->first();

        if (!$address) {
            return response()->json([
                'status' => false,
                'message' => 'Address not found.'
            ], 404);
        }

        $address->delete();

        return response()->json([
            'status' => true,
            'message' => 'Address deleted successfully.'
        ]);
    }
}
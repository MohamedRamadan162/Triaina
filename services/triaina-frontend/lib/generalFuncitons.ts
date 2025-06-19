export const getUserColor = (userId: string) => {
    const colors = [
        "bg-red-500", "bg-blue-500", "bg-green-500",
        "bg-yellow-500", "bg-purple-500", "bg-pink-500",
        "bg-indigo-500", "bg-orange-500", "bg-teal-500"
    ];

    // Simple hash function to consistently map a user ID to a color
    const hash = userId.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0);
    return colors[hash % colors.length];
};
export const getInitials = (name: string) => {
        return name
            .split(' ')
            .map(part => part[0])
            .join('')
            .toUpperCase()
            .slice(0, 2);
};